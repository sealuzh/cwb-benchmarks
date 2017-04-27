require 'cwb'
require 'open3'

# Guidance on Sysbench Threads Tests:
# * https://wiki.gentoo.org/wiki/Sysbench#Using_the_threads_workload
# * http://blog.siphos.be/2013/04/comparing-performance-with-sysbench-part-2/
class SysbenchThreads < Cwb::Benchmark
  def execute
    stdout, stderr, status = Open3.capture3(threads_cmd(1))
    raise "[sysbench/threads-1] #{stderr}" unless status.success?
    @cwb.submit_metric('sysbench/threads-1-duration', timestamp, extract_duration(stdout))
    @cwb.submit_metric('sysbench/threads-1-latency', timestamp, extract_latency(stdout))

    stdout, stderr, status = Open3.capture3(threads_cmd(128))
    raise "[sysbench/threads-128] #{stderr}" unless status.success?
    @cwb.submit_metric('sysbench/threads-128-duration', timestamp, extract_duration(stdout))
    @cwb.submit_metric('sysbench/threads-128-latency', timestamp, extract_latency(stdout))
  end

  def threads_cmd(num_threads = 1)
    "sysbench --test=threads --thread-locks=1 --num-threads=#{num_threads}  run"
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
