require 'cwb'
require 'open3'

# Guidance on Sysbench CPU Tests: https://wiki.mikejung.biz/Sysbench#Sysbench_CPU_Tests
# Recommended to test single and multi thread performance to check how well the CPUs scale
class SysbenchCpu < Cwb::Benchmark
  def execute
    stdout, stderr, status = Open3.capture3(single_thread_cmd)
    raise "[sysbench/cpu-single-thread] #{stderr}" unless status.success?
    @cwb.submit_metric('sysbench/cpu-single-thread-duration', timestamp, extract_duration(stdout))

    stdout, stderr, status = Open3.capture3(multi_thread_cmd)
    raise "[sysbench/cpu-multi-thread] #{stderr}" unless status.success?
    @cwb.submit_metric('sysbench/cpu-multi-thread-duration', timestamp, extract_duration(stdout))
  end

  def single_thread_cmd
    'sysbench --test=cpu --cpu-max-prime=20000 --num-threads=1 run'
  end

  def multi_thread_cmd
    "sysbench --test=cpu --cpu-max-prime=20000 --num-threads=#{cpu_cores} run"
  end

  def timestamp
    Time.now.to_i
  end

  def cpu_cores
    @cwb.deep_fetch('cpu', '0', 'cores').to_i
  end

  def extract_duration(string)
    string[/total time:\s*(\d+\.\d+s)/, 1]
  end
end
