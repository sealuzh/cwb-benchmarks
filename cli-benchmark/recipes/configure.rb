cwb_benchmark 'cli-benchmark'

install_cmd = node['cli-benchmark']['install']
execute 'cli-benchmark install command' do
  command install_cmd
  action :run
  only_if { !install_cmd.nil? }
end
