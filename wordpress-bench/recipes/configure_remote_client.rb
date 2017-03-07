wordpress = Cwb::BenchmarkUtil.new('wordpress-bench', node)
cwb_benchmark 'wordpress-bench'

cookbook_file wordpress.path_for('test_plan.jmx') do
  cwb_defaults(self)
  source 'test_plan.jmx'
  cookbook node['wordpress-bench']['test_plan_cookbook']
end

cookbook_file wordpress.path_for('wordpress_bench_client.rb') do
  cwb_defaults(self)
  source 'wordpress_bench_client.rb'
end
