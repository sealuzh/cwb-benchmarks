require 'cwb'

class Sysbench < Cwb::Benchmark
  def execute
    @cwb.submit_metric(cpu_metric, timestamp, cpu_model_name) rescue(puts 'Failed to submit cpu metric')
    execution_time = extract_time(run_sysbench)
    @cwb.submit_metric(execution_time_metric, timestamp, execution_time)
  end

  def timestamp
    Time.now.to_i
  end

  def cpu_model_name
    @cwb.deep_fetch('cpu', '0', 'model_name')
  end

  def run_sysbench
    result = `#{sysbench_cmd}`
    raise "Sysbench command '#{sysbench_cmd}' exited with statuscode '#{$CHILD_STATUS.exitstatus}'.\n
           #{result}" unless $CHILD_STATUS.success?
    result
  end

  def sysbench_cmd
    "sysbench #{flatten_cli_options(cli_options)} run"
  end

  def cli_options
    @cwb.deep_fetch('sysbench', 'cli_options')
  end

  # Converts a hash of cli options into an argument string
  # @example
  #           cli_options = { 'test' => 'cpu',
  #                           'cpu-max-prime' => 20_000,
  #                           'debug' => nil }
  #           flatten_cli_options(cli_option) => --test=cpu --cpu-max-prime=20000 --debug
  def flatten_cli_options(options)
    cli_options = ''
    return cli_options if options.empty?
    options.each do |key, value|
      cli_options << "--#{key}"
      cli_options << "=#{value}" unless value.to_s.empty?
      cli_options << ' ';
    end
    cli_options
  end

  def cpu_metric
    @cwb.deep_fetch('sysbench', 'metrics', 'cpu')
  end

  def execution_time_metric
    @cwb.deep_fetch('sysbench', 'metrics', 'execution_time')
  end

  def extract_time(string)
    string[/total time:\s*(\d+\.\d+)s/, 1]
  end
end
