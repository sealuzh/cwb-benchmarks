require 'cwb'
require 'faraday'
require 'faraday_middleware'

class WordpressBench < Cwb::Benchmark
  def execute
    all_services('start')
    start_load_generator
    wait_for_completion
    all_services('stop')
    # Give the instance some time to recover
    sleep 30
  end

  def all_services(op)
    services.each { |s| service(s, op) }
  end

  def service(name, op)
    `sudo service #{name} #{op}`
  end

  def services
    %w(mysql-default apache2 perfmon)
  end

  def wait_for_completion
    server = TCPServer.new(host, port)
    session = server.accept
    session.puts 'OK'
    session.close
  end

  def host
    '0.0.0.0'
  end

  def port
    5678
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
    Faraday.new(url: "http://#{load_generator}") do |f|
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
