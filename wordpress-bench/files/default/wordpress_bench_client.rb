require 'csv'
require 'cwb'
require 'open3'

class WordpressBenchClient < Cwb::Benchmark
  def execute
    num_repetitions.times do
      run_scenario
    end
    notify_completion
    # Exit with success without bothering about notifyingthat the
    # execution is finished because this would terminate the benchmark.
    exit
  end

  def run_scenario
    delete_old_results
    create_properties_file
    cmd = runremote? ? run_cmd_remote : run_cmd
    stdout, stderr, status = Open3.capture3(cmd)
    raise "[wordpress-bench] #{stderr}" unless status.success?
    results = process_results
    @cwb.submit_metric(metric_name, timestamp, results[:average_response_time])
    @cwb.submit_metric('wordpress-bench/num_failures', timestamp, results[:num_failures])
    @cwb.submit_metric('wordpress-bench/failure_rate', timestamp, results[:failure_rate])
  end

  def delete_old_results
    File.delete(results_file) if File.exist?(results_file)
  end

  def results_file
    'scenario1-read-only.csv'
  end

  def create_properties_file
    open(properties_file, 'w') do |f|
      properties.each do |key, value|
        f << "#{key}=#{value}\n"
      end
    end
  end

  def properties
    @cwb.deep_fetch('wordpress-bench', 'jmeter', 'properties')
  end

  def properties_file
    'test_plan.properties'
  end

  def runremote?
    @cwb.deep_fetch('wordpress-bench', 'jmeter', 'runremote').to_s == 'true'
  end

  def run_cmd
    "jmeter --nongui --testfile test_plan.jmx --addprop #{properties_file}"
  end

  def run_cmd_remote
    "jmeter --nongui --testfile test_plan.jmx --addprop #{properties_file} --runremote -G#{properties_file}"
  end

  def timestamp
    Time.now.to_i
  end

  def metric_name
    @cwb.deep_fetch('wordpress-bench', 'metric_name')
  end

  def num_repetitions
    @cwb.deep_fetch('wordpress-bench', 'num_repetitions').to_i
  end

  # NOTE: Fails if count == 0
  def process_results
    total = 0
    count = 0
    num_failures = 0
    CSV.foreach(results_file, headers: true) do |row|
      unless is_parent(row) # skip aggregated parent rows
        total += row['elapsed'].to_i
        count += 1
        (num_failures += 1) if (row['success'] != 'true')
      end
    end
    results = {
      average_response_time: (total.to_f / count),
      num_failures: num_failures,
      failure_rate: (num_failures.to_f / total),
    }
  end

  def is_parent(row)
    row['label'].include?(' => ')
  end

  def notify_completion
    server = TCPSocket.new(host, port)
    line = server.gets
    raise "[iperf/load-generator] Could not notify completion to #{host}:#{port}" if line.strip != 'OK'
    server.close
  end

  def host
    @cwb.deep_fetch('wordpress-bench','jmeter','properties','site')
  end

  def port
    5678
  end
end
