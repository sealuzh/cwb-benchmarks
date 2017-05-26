# Declare a CWB benchmark
# Make sure you create the corresponding
# benchmark file in files/default/benchmark_name.rb
cwb_benchmark 'software-microbenchmarking-runner'

framework = Cwb::BenchmarkUtil.new('software-microbenchmarking-runner', node)
cookbook_file framework.path_for('framework.rb') do
  cwb_defaults(self)
  source 'framework.rb'
end

jmh_projects = Cwb::BenchmarkUtil.new('software-microbenchmarking-runner', node)
cookbook_file jmh_projects.path_for('jmh_projects.rb') do
  cwb_defaults(self)
  source 'jmh_projects.rb'
end
