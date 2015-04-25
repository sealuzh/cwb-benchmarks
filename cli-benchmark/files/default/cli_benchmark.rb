require 'cwb'

class CliBenchmark < Cwb::Benchmark
  def execute
    pre_run
    @cwb.submit_metric('cpu', timestamp, cpu_model_name) rescue nil
    output = `#{run_cmd}` unless run_cmd.empty?
    fail "Run script '#{run_cmd} did exit unsuccessfully." unless $?.success?
    @cwb.submit_metric(metric_name, timestamp, result(output))
  end

  def pre_run
    pre_run_script = fetch('pre_run') || ''
    unless pre_run_script.empty?
      success = system(pre_run_script)
      fail "Pre run script '#{pre_run_script}' did exit unsuccessfully." unless success
    end
  end

  def cpu_model_name
    @cwb.deep_fetch('cpu', '0', 'model_name')
  end

  def timestamp
    Time.now.to_i
  end

  def run_cmd
    fetch('run')
  end

  def metric_name
    fetch('metric') || 'UNDEFINED'
  end

  def fetch(attribute)
    @cwb.deep_fetch('cli-benchmark', attribute)
  end

  def result_regex
    Regexp.new(fetch('regex'))
  end

  def result(output)
    output[result_regex, 1] || output[result_regex]
  end
end
