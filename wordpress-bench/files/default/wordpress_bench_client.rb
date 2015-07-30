require 'csv'
require 'cwb'

class WordpressBenchClient < Cwb::Benchmark
  def execute
    num_repetitions.times do
      run_scenario
    end
  end

  def run_scenario
    delete_old_results
    create_properties_file
    system(run_cmd)
    fail 'JMeter exited with non-zero value' unless $?.success?
    results = process_results
    @cwb.submit_metric(metric_name, timestamp, results[:average_response_time])
    @cwb.submit_metric('num_failures', timestamp, results[:num_failures])
    @cwb.submit_metric('failure_rate', timestamp, results[:failure_rate])
  end

  def delete_old_results
    File.delete(results_file) if File.exist?(results_file)
  end

  def results_file
    'results.csv'
  end

  def create_properties_file
    open(properties_file, 'w') do |f|
      properties.each do |key, value|
        f << "#{key} = #{value}\n"
      end
    end
  end

  def properties
    @cwb.deep_fetch('wordpress-bench', 'jmeter', 'properties')
  end

  def properties_file
    'test_plan.properties'
  end

  def run_cmd
    "jmeter --nongui --testfile test_plan.jmx --addprop #{properties_file}"
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
      total += row['elapsed'].to_i
      count += 1
      (num_failures += 1) if (row['success'] != 'true')
    end
    results = {
      average_response_time: (total.to_f / count),
      num_failures: num_failures,
      failure_rate: (num_failures.to_f / total),
    }
  end
end
