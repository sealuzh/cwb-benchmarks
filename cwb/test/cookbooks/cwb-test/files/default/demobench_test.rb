require 'cwb'

class DemobenchTest < Cwb::Benchmark
  def execute
    @cwb.submit_metric('date', timestamp, `date`)
  end

  def timestamp
    Time.now.to_i
  end

  def metric_name
    @cwb.deep_fetch('cwb-test', 'metric_name')
  end
end
