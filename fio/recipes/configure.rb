# Enable io redirect per default
# + easier for debugging
# * should not affect benchmark performance as no output is written to stdout during the benchmark
node.default['benchmark']['logging_enabled'] = 'true'

fio = Cwb::BenchmarkUtil.new('fio', node)

cwb_benchmark 'fio'

# Create the fio_job.ini configuration template
template fio.path_for(node['fio']['config_file']) do
  cwb_defaults(self)
  source node['fio']['template_name']
  cookbook node['fio']['template_cookbook']
  variables(
    config: node['fio']['config']
  )
end

# Postprocessing helper
 cookbook_file fio.path_for('fio_log_parser.rb') do
  cwb_defaults(self)
  source 'fio_log_parser.rb'
  mode '0755'
end
