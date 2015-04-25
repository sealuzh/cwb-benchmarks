require 'cwb'

class BenchmarkName < Cwb::Benchmark
  def execute
    @cwb.submit_metric('cpu', timestamp, cpu_model_name) rescue nil
    result = `BENCHMARK_COMMAND`
    @cwb.submit_metric('METRIC_NAME', timestamp, extract(result))
  end

  def timestamp
    Time.now.to_i
  end

  def cpu_model_name
    @cwb.deep_fetch('cpu', '0', 'model_name')
  end

  def access_attribute
    @cwb.deep_fetch('benchmark-name', 'attribute_1')
  end

  def extract(string)
    string[/YOUR_REGEX_(WITH_CAPTURE)_GROUP/, 1]
  end
end
