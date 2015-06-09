require 'cwb'
require 'faraday'
require 'faraday_middleware'

class WordpressBench < Cwb::Benchmark
  def execute
    @cwb.submit_metric('cpu', timestamp, cpu_model_name) rescue nil
    start_service('mysql')
    start_service('apache2')
    start_load_generator
    # HACK: Exit with success without bothering about notifying that
    # the execution is finished. The load generator will do this.
    exit
  end

  def timestamp
    Time.now.to_i
  end

  def cpu_model_name
    @cwb.deep_fetch('cpu', '0', 'model_name')
  end

  def start_service(name)
    `sudo service #{name} start`
  end

  def start_load_generator
    connection = setup_connection
    payload = {
      jmeter_task: {
        test_plan_file: Faraday::UploadIO.new('test_plan.jmx', 'application/x-jmeter'),
        benchmark_file: Faraday::UploadIO.new('wordpress_bench_client.rb', 'application/x-ruby'),
        node_file: Faraday::UploadIO.new('../node.yml', 'text/x-yaml'),
      }
    }
    connection.post '/jmeter_tasks', payload
  end

  def setup_connection
    Faraday.new(:url => load_generator) do |f|
      f.request :multipart
      f.request :json
      f.response :json
      f.adapter Faraday.default_adapter
    end
  end

  def load_generator
    @cwb.deep_fetch('wordpress-bench', 'load_generator')
  end
end
