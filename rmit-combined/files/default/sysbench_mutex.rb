require 'cwb'
require 'open3'

# Guidance on Sysbench Mutex Tests:
# * http://blog.siphos.be/2013/04/comparing-performance-with-sysbench-part-2/
class SysbenchMutex < Cwb::Benchmark
  def execute
    run('sysbench/mutex', mutex_cmd)
  end

  def run(name, cmd)
    stdout, stderr, status = Open3.capture3(cmd)
    raise "[#{name}] #{stderr}" unless status.success?
    @cwb.submit_metric('#{name}-duration', timestamp, extract_duration(stdout))
    @cwb.submit_metric('#{name}-latency', timestamp, extract_latency(stdout))
  end

  def mutex_cmd
    'sysbench --test=mutex --mutex-num=1 --mutex-locks=50000000 --mutex-loops=1 run'
  end

  def timestamp
    Time.now.to_i
  end

  def extract_duration(string)
    string[/total time:\s*(\d+\.\d+s)/, 1]
  end

  def extract_latency(string)
    string[/avg:\s+(\d*.\d*ms)/, 1]
  end
end
