module WordpressBench
  # Client for the fake data generation Wordpress plugin FakerPress
  # @see https://github.com/bordoni/fakerpress
  # @note quantity must not exceed 25
  # @example
  # faker = WordpressBench::FakerPress.new('http://192.168.33.33')
  # faker.login('admin', 'admin')
  # faker.save_api_key('CUSTOMER_KEY')
  # faker.generate_users(1, roles: 'Author,Subscriber')
  # faker.generate_terms(1)
  # faker.generate_posts(1, featured_image_rate: 100)
  # faker.generate_comments(1)
  # faker.delete_all_fake_data
  class FakerPress
    def initialize(url)
      # Solution #1 according to: https://sethvargo.com/using-gems-with-chef/
      # Dependencies must be installed first (even with compile_time = true)
      require 'faraday'
      require 'faraday-cookie_jar'
      require 'nokogiri'
      @url = url
      @conn = Faraday.new(url: url) do |f|
        f.request  :url_encoded
        f.use :cookie_jar
        f.adapter Faraday.default_adapter
      end
    end

    def index
      @conn.get '/'
    end

    def login(user, password)
      @conn.post '/wp-login.php', { log: user, pwd: password, rememberme: 'forever' }
    end

    # @param [String] 500px customer key (not secret key!) which can
    # be created here: https://500px.com/settings/applications
    # @note API rate limit is 1'000'000 requests / month / account
    # according to https://github.com/500px/api-documentation
    def save_api_key(customer_key)
      url = '/wp-admin/admin.php?page=fakerpress'
      @conn.post url, {
        '_wpnonce' => wpnonce(url),
        '_wp_http_referer' => url,
        'fakerpress[erase_phrase]' => '',
        'fakerpress[500px-key]' => customer_key,
        'fakerpress[actions][save_500px]' => 'Save'
      }
    end

    def delete_all_fake_data
      url = '/wp-admin/admin.php?page=fakerpress'
      @conn.post url, {
        '_wpnonce' => wpnonce(url),
        '_wp_http_referer' => url,
        'fakerpress[erase_phrase]' => 'Let it Go!',
        'fakerpress[500px-key]' => '',
        'fakerpress[actions][delete]' => 'Delete!',
      }
    end

    def generate_users(min, opts = {})
      url = '/wp-admin/admin.php?page=fakerpress&view=users'
      @conn.post url, {
        '_wpnonce' => wpnonce(url),
        '_wp_http_referer' => url,
        'fakerpress[qty][min]' => min,
        'fakerpress[qty][max]' => opts[:max] || '',
        'fakerpress[use_html]' => opts[:use_html] || 1,
        'fakerpress[html_tags]' => opts[:html_tags] || 'h3,h4,h5,h6,p',
        'fakerpress[roles]' => opts[:roles] || '',
        'submit' => 'Generate'
      }
    end

    def generate_posts(min, opts = {})
      url = '/wp-admin/admin.php?page=fakerpress&view=posts'
      @conn.post url, {
        '_wpnonce' => wpnonce(url),
        '_wp_http_referer' => url,
        'fakerpress[qty][min]' => min,
        'fakerpress[qty][max]' => opts[:max] || '',
        'fakerpress[post_types]' => opts[:post_types] || 'post',
        'fakerpress[post_parent]' => opts[:post_parent] || 1,
        'fakerpress[comment_status]' => opts[:comment_status] || 'open',
        'fakerpress[use_html]' => opts[:use_html] ||  1,
        'fakerpress[html_tags]' => opts[:html_tags] || 'h1,h2,h3,h4,h5,h6,ul,ol,div,p,blockquote,img,hr,!-- more --',
        'fakerpress[taxonomies]' => opts[:taxonomies] || 'post_tag,category',
        'fakerpress[featured_image_rate]' => opts[:featured_image_rate] || 75,
        'fakerpress[images_origin]' => opts[:images_origin] || 'placeholdit,500px',
        'fakerpress[author]' => opts[:author] || '',
        'fakerpress[date][min]' => opts[:date_min] || '',
        'fakerpress[date][max]' => opts[:date_max] || '',
        'submit' => 'Generate'
      }
    end

    def generate_comments(min, opts = {})
      url = '/wp-admin/admin.php?page=fakerpress&view=comments'
      @conn.post url, {
        '_wpnonce' => wpnonce(url),
        '_wp_http_referer' => url,
        'fakerpress[qty][min]' => opts[:min] || 1,
        'fakerpress[qty][max]' => opts[:max] || '',
        'fakerpress[use_html]' => opts[:use_html] || 1,
        'fakerpress[html_tags]' => opts[:html_tags] || 'h1,h2,h3,h4,h5,h6,ul,ol,div,p,blockquote',
        'fakerpress[date][min]' => opts[:date_min] || '',
        'fakerpress[date][max]' => opts[:date_max] || '',
        'submit' => 'Generate'
      }
    end

    def generate_terms(min, opts = {})
      url = '/wp-admin/admin.php?page=fakerpress&view=terms'
      @conn.post url, {
        '_wpnonce' => wpnonce(url),
        '_wp_http_referer' => url,
        'fakerpress[qty][min]' => min,
        'fakerpress[qty][max]' => opts[:max] || '',
        'fakerpress[taxonomies]' => opts[:taxonomies] || 'category',
        'submit' => 'Generate'
      }
    end

    private

      def wpnonce(url)
        body = @conn.get(url).body
        doc = Nokogiri::HTML(body)
        doc.xpath('//input[@type="hidden" and @name="_wpnonce" and @id="_wpnonce"]/@value').first.value
      end
  end
end
