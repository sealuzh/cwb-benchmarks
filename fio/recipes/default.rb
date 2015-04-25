include_recipe "fio::install_#{node['fio']['install_method']}"
include_recipe "fio::configure"
