require 'csv'
require 'cwb'
require 'open3'
require 'socket'

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
    create_properties_file
    cmd = runremote? ? run_cmd_remote : run_cmd
    stdout, stderr, status = Open3.capture3(cmd)
    raise "[wordpress-bench] #{stderr}" unless status.success?
    deliver_results('wordpress-bench/s1', 'scenario1-read-only.csv')
    deliver_results('wordpress-bench/s2', 'scenario2-read-and-search.csv')
    deliver_results('wordpress-bench/s3', 'scenario3-write-comment.csv')
  end

  def deliver_results(scenario, results_file)
    results = process_results(results_file)
    @cwb.submit_metric("#{scenario}-response_time", timestamp, results[:response_time])
    @cwb.submit_metric("#{scenario}-num_failures", timestamp, results[:num_failures])
    @cwb.submit_metric("#{scenario}-failure_rate", timestamp, results[:failure_rate])
    @cwb.submit_metric("#{scenario}-throughput", timestamp, results[:throughput])
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

  def num_repetitions
    @cwb.deep_fetch('wordpress-bench', 'num_repetitions').to_i
  end

  # NOTE: Fails if num_requests == 0
  # Metrics as defined in the JMeter documentation:
  # https://jmeter.apache.org/usermanual/glossary.html
  def process_results(results_file)
    total_time = 0
    num_requests = 0
    num_failures = 0
    CSV.foreach(results_file, headers: true) do |row|
      unless is_parent(row) # skip aggregated parent rows
        total_time += row['elapsed'].to_i
        num_requests += 1
        (num_failures += 1) if (row['success'] != 'true')
      end
    end
    results = {
      response_time: (total_time.to_f / num_requests), # in ms
      num_failures: num_failures, # count
      failure_rate: (num_failures.to_f / total_time), # in %
      throughput: num_requests.to_f / (total_time.to_f / 1000) # in seconds
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
    5679
  end
end
