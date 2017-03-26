require 'cwb'
require 'open3'

# Guidance on Sysbench Memory Tests: http://blog.siphos.be/2013/04/comparing-performance-with-sysbench-part-2/
# Tested different load for `memory-total-size` in range [1,1000] but the throughput doesn't differ,
# therefore taking a small load to complete quickly.
class SysbenchMemory < Cwb::Benchmark
  def execute
    stdout, stderr, status = Open3.capture3(default_block_size_cmd)
    raise "[sysbench/memory-default-block-size] #{stderr}" unless status.success?
    @cwb.submit_metric('sysbench/memory-default-block-size', timestamp, extract(stdout))

    stdout, stderr, status = Open3.capture3(large_block_size_cmd)
    raise "[sysbench/memory-large-block-size] #{stderr}" unless status.success?
    @cwb.submit_metric('sysbench/memory-large-block-size', timestamp, extract(stdout))
  end

  def default_block_size_cmd
    'sysbench --test=memory --memory-total-size=1G run'
  end

  def large_block_size_cmd
    'sysbench --test=memory --memory-block-size=1M --memory-total-size=10G run'
  end

  def timestamp
    Time.now.to_i
  end

  def extract(string)
    string[/transferred \((\d+.\d* MB\/sec)\)/, 1]
  end
end
