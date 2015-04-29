bm = Cwb::BenchmarkUtil.new('sysbench-monitored', node)
cwb_benchmark 'sysbench-monitored'

cookbook_file bm.path_for('cpu_monitor.rb') do
  cwb_defaults(self)
end

cookbook_file bm.path_for('sar_parser.rb') do
  cwb_defaults(self)
end
