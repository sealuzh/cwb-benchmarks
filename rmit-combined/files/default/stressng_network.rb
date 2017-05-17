require 'cwb'
require 'open3'

# Guidance on stress-ng local Network Tests:
# * HTML overview docs: http://kernel.ubuntu.com/~cking/stress-ng/
# * Detailed docs: http://kernel.ubuntu.com/~cking/stress-ng/stress-ng.pdf
# * https://wiki.ubuntu.com/Kernel/Reference/stress-ng
class StressngNetwork < Cwb::Benchmark
  def execute
    stdout, stderr, status = Open3.capture3(cmd(exclude))
    raise "[stressng/network] #{stderr}" unless status.success?
    @cwb.submit_metric("stressng/network-total-duration", timestamp, extract_duration(stderr))
    methods.each do |method|
      @cwb.submit_metric("stressng/network-#{method}-bogo-ops", timestamp, extract_bogo_ops(stderr, method))
    end
  end

  # There is no include flag but only an exclude flag
  # So a way to run a subset of the network benchmarks is to
  # use the `--exclude` flag from the list of all benchmarks available
  def exclude
    all - methods
  end

  def methods
    %w(epoll icmp-flood sockfd udp)
  end

  def all
    %w(dccp epoll icmp-flood sctp sock sockfd sockpair udp udp-flood)
  end

  # Some stressors require root permission (e.g., icmp-flood)
  def cmd(exclude)
    "sudo stress-ng --sequential 1 --class network -t 10 --metrics-brief --exclude #{exclude.join(',')}"
  end

  def timestamp
    Time.now.to_i
  end

  def extract_duration(string)
    string[/stress-ng: info:  \[\d*\] successful run completed in (\d*.\d*s)/, 1]
  end

  # bogo ops/s (real time)
  def extract_bogo_ops(string, method)
    string[/stress-ng: info:  \[\d*\] #{method}\s+(\d*.\d*)\s+(\d*.\d*)\s+(\d*.\d*)\s+(\d*.\d*)\s+(\d*.\d*)\s+(\d*.\d*)/, 5]
  end
end
