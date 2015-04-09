require 'cwb'

class Sysbench < Cwb::Benchmark
  def execute
    @cwb.submit_metric('time', '0', `date`)
  end
end
