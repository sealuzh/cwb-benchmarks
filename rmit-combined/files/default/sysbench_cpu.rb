require 'cwb'
require 'open3'

# Guidance on Sysbench CPU Tests: https://wiki.mikejung.biz/Sysbench#Sysbench_CPU_Tests
# Recommended to test single and multi thread performance to check how well the CPUs scale
class SysbenchCpu < Cwb::Benchmark
  def execute
    run('sysbench/cpu-single-thread', single_thread_cmd)
    run('sysbench/cpu-multi-thread', multi_thread_cmd)
  end

  def run(name, cmd)
    stdout, stderr, status = Open3.capture3(cmd)
    raise "[#{name}] #{stderr}" unless status.success?
    @cwb.submit_metric("#{name}-duration", timestamp, extract_duration(stdout))
  end

  def single_thread_cmd
    'sysbench --test=cpu --cpu-max-prime=20000 --num-threads=1 run'
  end

  def multi_thread_cmd
    "sysbench --test=cpu --cpu-max-prime=20000 --num-threads=#{num_cpu_cores} run"
  end

  def num_cpu_cores
    @cwb.deep_fetch('cpu', 'total').to_i
  end

  def timestamp
    Time.now.to_i
  end

  def extract_duration(string)
    string[/total time:\s*(\d+\.\d+s)/, 1]
  end
end
