include_recipe 'sysbench::install'
# sysbench.rb implementation required but should not include sysbench to run list
cwb_benchmark 'sysbench' do
  cookbook 'sysbench'
  action :create
end

include_recipe 'apt'
package 'sysstat' do
  action :install
end
