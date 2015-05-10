include_recipe 'apt'
include_recipe 'build-essential'

simulation = Cwb::BenchmarkUtil.new('molecular-dynamics-simulation', node)

cwb_benchmark simulation.name

code_file = simulation.path_for('md_sim.c')
cookbook_file code_file do
  cwb_defaults(self)
  source 'md_sim.c'
  action :create
  notifies :run, 'execute[compile_code]'
end

execute 'compile_code' do
  cwd simulation.path
  command 'g++ -fopenmp -o md_sim md_sim.c'
  action :nothing
end
