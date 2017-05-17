require 'open3'
require 'socket'

# Also see `iperf.rb`
class IperfClient < Cwb::Benchmark
  DURATION = 30 # seconds

  def execute
    run('single-thread', cmd(1))
    run('multi-thread', cmd(num_cpu_cores))
    notify_completion
    # Exit with success without bothering about notifying that the
    # execution is finished because this would terminate the benchmark.
    exit
  end

  def run(method, cmd)
    stdout, stderr, status = Open3.capture3(cmd)
    raise "[iperf/load-generator-#{method}] #{stderr}" unless status.success?
    @cwb.submit_metric("iperf/#{method}-duration", timestamp, DURATION)
    @cwb.submit_metric("iperf/#{method}-bandwidth", timestamp, extract_bandwidth(stdout))
  end

  def cmd(num_threads)
    "iperf -c #{host} -l 128k -t #{DURATION} -P #{num_threads}"
  end

  def num_cpu_cores
    @cwb.deep_fetch('cpu', '0', 'cores').to_i
  end

  def notify_completion
    server = TCPSocket.new(host, port)
    line = server.gets
    raise "[iperf/load-generator] Could not notify completion to #{host}:#{port}" if line.strip != 'OK'
    server.close
  end

  def host
    @cwb.deep_fetch('rmit-combined', 'public_host')
  end

  def port
    5678
  end

  def cpu_cores
    @cwb.deep_fetch('cpu', '0', 'cores').to_i
  end

  def timestamp
    Time.now.to_i
  end

  def extract_bandwidth(string)
    string.lines.last[/(\d*.\d* \w+\/sec)/, 1]
  end
end
