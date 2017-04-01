require 'cwb'
require 'open3'
require 'fileutils'

# Guidance on Sysbench Fileio Tests:
# * https://wiki.mikejung.biz/Sysbench#Sysbench_Fileio_Options
#   * Blocksize: 4k for rand, 1m for seq: https://wiki.mikejung.biz/Sysbench#Sysbench_Fileio_file-block-size
# * http://blog.siphos.be/2013/04/comparing-performance-with-sysbench/
#   * Database: rand read (for select data) + seq write (transaction logs)
#   * File server: rand read/write
# Make sure your instance has enough disk space attached. An example how to increase disk space on AWS can be found here:
# https://github.com/cruskit/vagrant-ghost/blob/master/Vagrantfile
class SysbenchFileio < Cwb::Benchmark
  def execute
    @cwb.submit_metric('sysbench/fileio-file-total-size', timestamp, "#{file_total_size_gb}G")
    run('sysbench/fileio-1m-seq-write', seq_write_cmd)
    cleanup_test_files
    run('sysbench/fileio-4k-rand-write', rand_write_cmd)
    cleanup_test_files
    run('sysbench/fileio-4k-rand-read', rand_read_cmd, rand_read_prepare)
    cleanup_test_files
  end

  def run(name, cmd, prepare = 'true')
    o, s = Open3.capture2(prepare)
    raise "[#{name}-prepare] #{s}" unless s.success?

    stdout, stderr, status = Open3.capture3(cmd)
    raise "[#{name}] #{stderr}" unless status.success?
    @cwb.submit_metric(name, timestamp, extract(stdout))
    @cwb.submit_metric("#{name}-throughput", timestamp, extract_throughput(stdout))
    @cwb.submit_metric("#{name}-latency", timestamp, extract_latency(stdout))
    @cwb.submit_metric("#{name}-latency-95-percentile", timestamp, extract_latency_percentile(stdout))
  end

  def seq_write_cmd
    "sysbench --test=fileio --file-total-size=#{file_total_size_gb}G --file-block-size=1M --file-test-mode=seqwr run"
  end

  def rand_write_cmd
    "sysbench --test=fileio --file-total-size=#{file_total_size_gb}G --file-block-size=4K --file-test-mode=rndwr run"
  end

  def rand_read_prepare
    "#{rand_read} prepare"
  end

  def rand_read_cmd
    "#{rand_read} run"
  end

  def rand_read
    "sysbench --test=fileio --file-total-size=#{file_total_size_gb}G --file-block-size=4K --file-test-mode=rndrd"
  end

  def cleanup_test_files
    FileUtils.rm Dir.glob("test_file.*")
  end

  def timestamp
    Time.now.to_i
  end

  # Recommended to be 2x the amount of RAM to avoid caching
  # Example: given 900 MB RAM, file_total_size_gb == 2
  def file_total_size_gb
    ((total_ram_mb.to_f * 2).to_f / 1024).ceil
  end

  def total_ram_mb
    node_ram_in_kB[/(\d*)kB/, 1].to_i / 1024
  end

  def node_ram_in_kB
    @cwb.deep_fetch('memory', 'total')
  end

  def extract(string)
    string[/total time:\s*(\d+\.\d+s)/, 1]
  end

  def extract_throughput(string)
    string[/Total transferred .*  \((\d*.\d*Mb\/sec)\)/, 1]
  end

  def extract_latency(string)
    string[/avg:\s+(\d*.\d*ms)/, 1]
  end

  def extract_latency_percentile(string)
    string[/approx.  95 percentile:\s+(\d*.\d*ms)/, 1]
  end
end
