require 'cwb'
require 'open3'
require 'fileutils'
require 'benchmark'

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

  def run(name, cmd, prepare_cmd = 'true')
    run_measured_prepare(name, prepare_cmd)

    stdout, stderr, status = Open3.capture3(cmd)
    raise "[#{name}] #{stderr}" unless status.success?
    @cwb.submit_metric("#{name}-duration", timestamp, extract_duration(stdout))
    @cwb.submit_metric("#{name}-throughput", timestamp, extract_throughput(stdout))
    @cwb.submit_metric("#{name}-latency", timestamp, extract_latency(stdout))
    @cwb.submit_metric("#{name}-latency-95-percentile", timestamp, extract_latency_percentile(stdout))
  end

  def run_measured_prepare(name, prepare_cmd)
    prepare_duration = Benchmark.realtime { run_prepare(name, prepare_cmd) }.round(2)
    @cwb.submit_metric("#{name}-prepare-duration", timestamp, prepare_duration) if prepare_cmd != 'true'
  end

  def run_prepare(name, prepare_cmd)
    o, s = Open3.capture2(prepare_cmd)
    raise "[#{name}-prepare] #{s}" unless s.success?
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

  def extract_duration(string)
    string[/total time:\s*(\d+\.\d+s)/, 1]
  end

  def extract_throughput(string)
    string[/Total transferred .*  \((\d*.\d*\wb\/sec)\)/, 1]
  end

  def extract_latency(string)
    string[/avg:\s+(\d*.\d*ms)/, 1]
  end

  def extract_latency_percentile(string)
    string[/approx.  95 percentile:\s+(\d*.\d*ms)/, 1]
  end
end
