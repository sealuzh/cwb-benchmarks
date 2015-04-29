cwb_benchmark 'cli-benchmark'

install_cmds = node['cli-benchmark']['install']
# Also support single strings and nil (i.e., no array)
install_cmds = [ install_cmds ] if install_cmds.class != Array

cmd = install_cmds.join('&& ')
execute "cli-benchmark install command" do
    command cmd
    action :run
    only_if { !cmd.nil? && !cmd.empty? }
end
