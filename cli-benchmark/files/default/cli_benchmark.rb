require 'cwb'

class CliBenchmark < Cwb::Benchmark
  def execute
    @cwb.submit_metric('cpu', timestamp, cpu_model_name) rescue nil
    repetitions.times do |i|
      execute_run
    end
  end

  def repetitions
    fetch('repetitions').to_i
  end

  def execute_run
    pre_run
    output = `#{run_cmd}` unless run_cmd.empty?
    fail "Run script '#{run_cmd} did exit unsuccessfully." unless $?.success?
    submit_metrics(output)
    post_run
  end

  def pre_run
    pre_run_script = fetch('pre_run') || ''
    unless pre_run_script.empty?
      success = system(pre_run_script)
      fail "Pre run script '#{pre_run_script}' did exit unsuccessfully." unless success
    end
  end

  def post_run
    post_run_script = fetch('post_run') || ''
    unless post_run_script.empty?
      success = system(post_run_script)
      fail "Post run script '#{post_run_script}' did exit unsuccessfully." unless success
    end
  end

  def submit_metrics(stdout)
    metrics.each do |metric_name, regex_string|
      @cwb.submit_metric(metric_name, timestamp, result(stdout, regex(regex_string)))
    end
  end

  def cpu_model_name
    @cwb.deep_fetch('cpu', '0', 'model_name')
  end

  def timestamp
    Time.now.to_i
  end

  def metrics
    fetch('metrics')
  end

  def run_cmd
    fetch('run')
  end

  def fetch(attribute)
    @cwb.deep_fetch('cli-benchmark', attribute)
  end

  def regex(string)
    Regexp.new(string)
  end

  def result(string, regex)
    string[regex, 1] || string[regex]
  end
end
