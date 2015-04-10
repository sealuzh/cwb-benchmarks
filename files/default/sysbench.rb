require 'cwb'

class Sysbench < Cwb::Benchmark
  def execute
    @cwb.submit_metric('time', '0', `date`)
    @cwb.submit_metrics('time', 'bulk.csv')
  end
end
