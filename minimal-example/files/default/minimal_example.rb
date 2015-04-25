require 'cwb'

class MinimalExample < Cwb::Benchmark
  def execute
    result = `sysbench --test=cpu --cpu-max-prime=#{cpu_max_prime} run`
    @cwb.submit_metric('execution-time', timestamp, total_time(result))
  end

  def timestamp
    Time.now.to_i
  end

  def cpu_max_prime
    @cwb.deep_fetch('minimal-example', 'cpu_max_prime')
  end

  def total_time(result)
    result[/total time:\s*(\d+\.\d+)s/, 1]
  end
end

