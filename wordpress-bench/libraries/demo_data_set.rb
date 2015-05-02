require 'yaml'
module WordpressBench
  class DemoDataSet
    # FakerPress is limits quantity to max 25
    # @param [String] path to directory wherein a text file
    # will be generated in order to keep track whether the
    # data set was already applied to achieve idempotence.
    def initialize(data_sets_dir)
      @data_sets_dir = data_sets_dir
    end

    def applied?
      File.exist?(admin_file)
    end

    def admin_file
      File.join(@data_sets_dir, 'demo_data_set.txt')
    end

    def set_applied!(content)
      File.write(admin_file, content)
    end

    def set_non_applied!
      File.delete(admin_file)
    end

    def apply!(faker)
      generate_users(faker)
      generate_terms(faker)
      generate_posts(faker)
      generate_comments(faker)
      set_applied!("Applied data set for:\n#{faker.to_yaml}")
    end

    def generate_users(faker)
      faker.generate_users(10, roles: 'Administrator')
      faker.generate_users(50, roles: 'Editor')
      faker.generate_users(100, roles: 'Author')
      faker.generate_users(500, roles: 'Contributor')
      faker.generate_users(1000, roles: 'Subscriber')
    end

    def generate_terms(faker)
      faker.generate_terms(20, taxonomies: 'category')
      faker.generate_terms(50, taxonomies: 'tags')
    end

    def generate_posts(faker)
      faker.generate_posts(20, {post_types: 'pages', featured_image_rate: 100}.merge(date_range))
      faker.generate_posts(800, {featured_image_rate: 75}.merge(date_range))
    end

    def generate_comments(faker)
      faker.generate_comments(4000, {}.merge(date_range))
    end

    def date_range
      {
        date_min: '01/01/2010',
        date_max: '01/01/2015',
      }
    end
  end
end
