require 'cwb'

class Date2 < Cwb::Benchmark
  def execute
    result = `date`
    @cwb.submit_metric('date', timestamp, "Date2:#{result}")
  end

  def timestamp
    Time.now.to_i
  end

  def metric_name
    @cwb.deep_fetch('benchmark-name', 'metric_name')
  end

  def extract(string)
    string[/YOUR_REGEX_(WITH_CAPTURE)_GROUP/, 1]
  end
end
