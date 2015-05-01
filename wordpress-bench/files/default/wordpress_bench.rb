require 'cwb'

class BenchmarkName < Cwb::Benchmark
  def execute
    @cwb.submit_metric('cpu', timestamp, cpu_model_name) rescue nil
    result = `BENCHMARK_COMMAND`
    @cwb.submit_metric(metric_name, timestamp, extract(result))
  end

  def timestamp
    Time.now.to_i
  end

  def cpu_model_name
    @cwb.deep_fetch('cpu', '0', 'model_name')
  end

  def metric_name
    @cwb.deep_fetch('wordpress-bench', 'metric_name')
  end

  def extract(string)
    string[/YOUR_REGEX_(WITH_CAPTURE)_GROUP/, 1]
  end
end
