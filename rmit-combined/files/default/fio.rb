require 'cwb'
require 'open3'
require 'fileutils'

# Guidance on Fio Tests:
# CLI examples: https://wiki.mikejung.biz/Benchmarking#Fio_Random_Write_and_Random_Read_Command_Line_Examples
# Fio output explained: https://tobert.github.io/post/2014-04-17-fio-output-explained.html
# Storagereview: http://www.storagereview.com/fio_flexible_i_o_tester_synthetic_benchmark
# Man pages: https://linux.die.net/man/1/fio
class Fio < Cwb::Benchmark
  def execute
    run('fio/4k-seq-write', seq_write_cmd)
    run('fio/8k-rand-write', rand_read_cmd)
    cleanup_test_files
  end

  def run(name, cmd)
    stdout, stderr, status = Open3.capture3(cmd)
    raise "[#{name}] #{stderr}" unless status.success?
    @cwb.submit_metric(name, timestamp, extract(stdout))
    @cwb.submit_metric("#{name}-bandwidth", timestamp, extract_throughput(stdout))
    @cwb.submit_metric("#{name}-iops", timestamp, extract_iops(stdout))
    @cwb.submit_metric("#{name}-latency", timestamp, extract_latency(stdout))
    @cwb.submit_metric("#{name}-latency-95-percentile", timestamp, extract_latency_percentile(stdout))
    @cwb.submit_metric("#{name}-disk-util", timestamp, extract_disk_util(stdout))
  end

  # Replicating the case study settings from the CloudCom2014 paper "Cloud Work Bench -- Infrastructure-as-Code Based Cloud Benchmarking"
  # * IEEExplore: http://ieeexplore.ieee.org/abstract/document/7037674/
  # * Arxiv: https://arxiv.org/pdf/1408.4565.pdf
  def seq_write_cmd
    'fio --name=write --numjobs=1 --ioengine=sync --rw=write --bs=4k --size=1g --direct=1 --refill_buffers=1 --filename=fio.tmp'
  end

  # Filesystem benchmark: http://dtrace.org/blogs/brendan/2014/01/10/benchmarking-the-cloud/
  def rand_read_cmd
    'fio --runtime=60 --time_based --clocksource=clock_gettime --name=randread --numjobs=1 --rw=randread --random_distribution=pareto:0.9 --bs=8k --size=2g --filename=fio.tmp'
  end

  def cleanup_test_files
    FileUtils.rm Dir.glob("fio.tmp*")
  end

  def timestamp
    Time.now.to_i
  end

  def extract(string)
    string[regex, 3]
  end

  def extract_throughput(string)
    string[regex, 1]
  end

  def extract_iops(string)
    string[regex, 2]
  end

  def regex
    /\w*\s*: io=.*, bw=(\d*.\d*KB\/s), iops=(\d*), runt=\s*(\d*msec)/
  end

  def extract_latency(string)
    string[/clat \(usec\): min=\d*, max=\d*, avg=(\d*.\d*), stdev=\d*.\d*/, 1]
  end

  def extract_latency_percentile(string)
    string[/95.00th=\[\s*(\d*)\],/, 1]
  end

  def extract_disk_util(string)
    string[/util=(\d*.\d*%)/, 1]
  end
end
