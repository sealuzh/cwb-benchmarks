module WordpressBench
  class WpCli
    attr_reader :bin
    # @param root [String] the wordpress root directory (i.e., parent_dir)
    # @param user [String] the wordpress system user
    # @param bin [String] assume that wp is within the PATH if passed nothing or nil
    def initialize(root, user, bin = nil)
      @root = root
      @user = user
      @bin = bin
    end

    # Required opts: url, title, admin_user, admin_password, admin_email
    def install_core!(opts)
      unless core_installed?
        run_cmd(wp_cmd("core install #{options_string(opts)}"))
        Chef::Log.info('Installed the wordpress core.')
      end
    end

    def update_url!(new_url)
      if siteurl != new_url || home != new_url
        run_cmd(wp_cmd("option update home #{new_url}"))
        run_cmd(wp_cmd("option update siteurl #{new_url}"))
        Chef::Log.info("Updated the Wordpress url to #{new_url}.")
      end
    end

    def install_plugin!(name, opts = {})
      unless plugin_installed?(name)
        run_cmd(wp_cmd("plugin install #{name} --activate #{options_string(opts)}"))
        Chef::Log.info("Installed and activated the Wordpress plugin #{name} #{options_string(opts)}.")
      end
    end

    def plugin_installed?(name)
      cmd = run_cmd(wp_cmd("plugin is-installed #{name}"), no_error: true)
      !cmd.error?
    end

    def wp_cmd(command)
      "#{wp} #{command}"
    end

    def wp
      bin.nil? ? 'wp' : "php #{@bin}"
    end

    def siteurl
      run_cmd(wp_cmd('option get siteurl')).stdout.strip
    end

    def home
      run_cmd(wp_cmd('option get home')).stdout.strip
    end

    def core_installed?
      cmd = run_cmd(wp_cmd('core is-installed'), no_error: true)
      !cmd.error?
    #   true
    # rescue => e
    #   no_output = "STDOUT: \nSTDERR: \n----"
    #   e.message.include?(no_output) ? (return false) : (raise e)
    end

    # Runs a command in the context of wordpress
    # @returns [Mixlib::ShellOut] the runned command
    def run_cmd(cmd, opts = {})
      cmd = Mixlib::ShellOut.new(cmd, cwd: @root, user: @user)
      cmd.run_command
      cmd.error! unless opts[:no_error] == true
      cmd
    end

    private

      def options_string(opts)
        options = ''
        opts.each do |key, value|
          options << "--#{key}=\"#{value}\" "
        end
        options
      end
  end
end
