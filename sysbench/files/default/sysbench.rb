require 'cwb'

class Sysbench < Cwb::Benchmark
  def execute
    @cwb.submit_metric('cpu', timestamp, cpu_model_name)
    result = `sysbench #{flatten_cli_options(cli_options)} run`
    @cwb.submit_metric('time', timestamp, extract_time(result))
  end

  def timestamp
    Time.now.to_i
  end

  def cpu_model_name
    @cwb.deep_fetch('cpu', '0', 'model_name')
  end

  def cli_options
    @cwb.deep_fetch('sysbench', 'cli_options')
  end

  def flatten_cli_options(options)
    cli_options = ''
    options.each do |key, value|
      cli_options << "--#{key}"
      cli_options << "=#{value}" unless value.to_s.empty?
      cli_options << ' ';
    end
    cli_options
  end

  def extract_time(string)
    string[/total time:\s*(\d+\.\d+)s/, 1]
  end
end
