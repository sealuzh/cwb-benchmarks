require 'cwb'
require 'open3'
require 'socket'
require 'faraday'
require 'faraday_middleware'

# Guidance on iperf network tests:
# * http://dtrace.org/blogs/brendan/2014/01/10/benchmarking-the-cloud/
# * https://www.linode.com/docs/networking/diagnostics/diagnosing-network-speed-with-iperf
# * https://www.jamescoyle.net/cheat-sheets/581-iperf-cheat-sheet
# * https://www.samkear.com/networking/iperf-commands-network-troubleshooting
# Requirements:
# * Open ports: 5001 (iperf), 5678 (for waiting tcp listener)
# Socket notification implementation based on:
# http://blog.appsignal.com/2016/11/23/ruby-magic-building-a-30-line-http-server-in-ruby.html
class Iperf < Cwb::Benchmark
  def execute
    run_sh(start_iperf_server_cmd)
    start_load_generator
    wait_for_completion
    run_sh(stop_iperf_server_cmd)
  end

  def start_iperf_server_cmd
    'iperf --server --len 128k --daemon'
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

  def stop_iperf_server_cmd
    'pkill -9 iperf'
  end

  def run_sh(cmd)
    success = system(cmd)
    raise "[iperf] #{stderr}" unless success
  end

  def start_load_generator
    connection = setup_connection
    payload = {
      jmeter_task: {
        benchmark_file: Faraday::UploadIO.new('iperf_client.rb', 'application/x-ruby'),
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
    @cwb.deep_fetch('rmit-combined', 'load_generator')
  end
end
