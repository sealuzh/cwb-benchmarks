require 'cwb'
require_relative 'fio_log_parser'

class Fio < Cwb::Benchmark
  RESULT_FILE = 'fio_results.csv'

  def execute
    @cwb.submit_metric('cpu', timestamp, cpu_model_name)
    cmd = "fio #{config_file} #{cli_options}"
    output = `#{cmd}`
    fail "Command '#{cmd}' exited with statuscode #{$CHILD_STATUS.exitstatus}:\n#{output}" unless $CHILD_STATUS.success?
    FioLogParser.parse_log(fio_log_file, RESULT_FILE)
    @cwb.submit_metrics(metric_definition_id, RESULT_FILE)
  end

  def config_file
    fio_attribute('config_file')
  end

  def cli_options
    fio_attribute('cli_options')
  end

  def fio_log_file
    "#{fio_config('write_bw_log')}_bw.1.log"
  end

  def metric_definition_id
    fio_attribute('metric_definition_id')
  end

  def timestamp
    Time.now.to_i
  end

  def cpu_model_name
    @cwb.deep_fetch('cpu', '0', 'model_name')
  end

  def fio_config(name)
    @cwb.deep_fetch('fio', 'config', name)
  end

  def fio_attribute(name)
    @cwb.deep_fetch('fio', name)
  end
end
