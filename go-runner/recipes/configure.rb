# Declare a CWB benchmark
# Make sure you create the corresponding
# benchmark file in files/default/benchmark_name.rb
cwb_benchmark 'go-runner'

# framework = Cwb::BenchmarkUtil.new('go-runner', node)
# cookbook_file framework.path_for('framework.rb') do
#   cwb_defaults(self)
#   source 'framework.rb'
# end

# go_projects = Cwb::BenchmarkUtil.new('go-runner', node)
# cookbook_file go_projects.path_for('go_projects.rb') do
#   cwb_defaults(self)
#   source 'go_projects.rb'
# end
