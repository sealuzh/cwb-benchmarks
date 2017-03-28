require 'cwb'
require 'open3'

# Guidance on stress-ng CPU Tests:
# * http://kernel.ubuntu.com/~cking/stress-ng/
# * https://wiki.ubuntu.com/Kernel/Reference/stress-ng
class StressngCpu < Cwb::Benchmark
  def execute
    methods.each do |method|
      run(method)
    end
  end

  def methods
    %w(callfunc double euler fibonacci fft int64 loop matrixprod)
  end

  def run(method)
    stdout, stderr, status = Open3.capture3(cmd(method))
    raise "[stressng/cpu-#{method}] #{stderr}" unless status.success?
    @cwb.submit_metric("stressng/cpu-#{method}", timestamp, extract(stderr))
    @cwb.submit_metric("stressng/cpu-#{method}-bogo-ops", timestamp, extract_bogo_ops(stderr))
  end

  def cmd(method)
    "stress-ng --cpu 1 --cpu-method #{method} -t 10 --metrics-brief"
  end

  def timestamp
    Time.now.to_i
  end

  def extract(string)
    string[/stress-ng: info:  \[\d*\] successful run completed in (\d*.\d*s)/, 1]
  end

  # bogo ops/s (real time)
  def extract_bogo_ops(string)
    string[/stress-ng: info:  \[\d*\] cpu .* (\d*.\d*)       .*/, 1]
  end
end
