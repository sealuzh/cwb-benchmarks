require 'cwb'

class SysbenchTest < Cwb::Benchmark
  def execute
    @cwb.submit_metric('cpu', timestamp, cpu_model_name) rescue nil
    result = `sysbench --test=cpu --cpu-max-prime=2000 run`
    @cwb.submit_metric(metric_name, timestamp, extract(result))
  end

  def timestamp
    Time.now.to_i
  end

  def cpu_model_name
    @cwb.deep_fetch('cpu', '0', 'model_name')
  end

  def metric_name
    @cwb.deep_fetch('cwb-test', 'metric_name')
  end

  def extract(string)
    string[/total time:\s*(\d+\.\d+)s/, 1]
  end
end
