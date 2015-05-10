require 'cwb'

class MolecularDynamicsSimulation < Cwb::Benchmark
  def execute
    @cwb.submit_metric('cpu', timestamp, cpu_model_name) rescue nil
    result = `./md_sim #{np}`
    @cwb.submit_metric(metric_name, timestamp, extract_time(result))
  end

  def timestamp
    Time.now.to_i
  end

  def cpu_model_name
    @cwb.deep_fetch('cpu', '0', 'model_name')
  end

  def np
    @cwb.deep_fetch('molecular-dynamics-simulation', 'np')
  end

  def metric_name
    @cwb.deep_fetch('molecular-dynamics-simulation', 'metric_name')
  end

  def extract_time(string)
    string[/  ((\d*[.])?\d+) seconds.\n/, 1]
  end
end
