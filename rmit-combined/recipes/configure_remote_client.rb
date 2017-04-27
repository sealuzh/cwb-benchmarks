iperf = Cwb::BenchmarkUtil.new('iperf', node)

cookbook_file iperf.path_for('iperf_client.rb') do
  cwb_defaults(self)
  source 'iperf_client.rb'
end
