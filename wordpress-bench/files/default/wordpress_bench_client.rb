require 'csv'
require 'cwb'

class WordpressBenchClient < Cwb::Benchmark
  def execute
    delete_old_results
    create_properties_file
    system(run_cmd)
    fail 'JMeter exited with non-zero value' unless $?.success?
    @cwb.submit_metric(metric_name, timestamp, average_response_time)
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

  def average_response_time
    total = 0
    count = 0
    CSV.foreach(results_file, headers: true) do |row|
      total += row['elapsed'].to_i
      count += 1
    end
    total.to_f / count
  end
end
