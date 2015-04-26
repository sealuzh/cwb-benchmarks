module Chef::Recipe::System
  include Chef::Mixin::ShellOut
  
  # @return [Boolean] true if the command is available in the path
  #                   false otherwise
  def command_exist?(cmd)
    cmd = Mixlib::ShellOut.new("which #{cmd}")
    cmd.run_command
    cmd.error?
  end
end
