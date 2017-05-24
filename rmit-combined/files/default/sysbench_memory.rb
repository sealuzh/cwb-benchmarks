require 'cwb'
require 'open3'

# Guidance on Sysbench Memory Tests: http://blog.siphos.be/2013/04/comparing-performance-with-sysbench-part-2/
# Tested different load for `memory-total-size` in range [1,1000] but the throughput doesn't differ,
# therefore taking a small load to complete quickly.
class SysbenchMemory < Cwb::Benchmark
  def execute
    run('sysbench/memory-default-block-size', default_block_size_cmd)
    run('sysbench/memory-large-block-size', large_block_size_cmd)
  end

  def run(name, cmd)
    stdout, stderr, status = Open3.capture3(cmd)
    raise "[#{name}] #{stderr}" unless status.success?
    @cwb.submit_metric("#{name}-duration", timestamp, extract_duration(stdout))
    @cwb.submit_metric("#{name}-throughput", timestamp, extract_throughput(stdout))
  end

  # Default: --memory-block-size=1K
  def default_block_size_cmd
    'sysbench --test=memory --memory-total-size=1G run'
  end

  def large_block_size_cmd
    'sysbench --test=memory --memory-block-size=1M --memory-total-size=10G run'
  end

  def timestamp
    Time.now.to_i
  end

  def extract_duration(string)
    string[/total time:\s*(\d+\.\d+s)/, 1]
  end

  def extract_throughput(string)
    string[/transferred \((\d+.\d* MB\/sec)\)/, 1]
  end
end
