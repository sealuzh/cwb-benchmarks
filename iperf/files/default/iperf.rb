require 'cwb'
require 'csv'

class Iperf < Cwb::Benchmark
  INPUT = 'iperf.txt'
  OUTPUT = 'iperf.csv'
  INTERVAL_REGEX = /\[\s*\d\]\s*(\d+)\.\d+\s*-\s*\d+\.\d+\ssec/
  BANDWIDTH_REGEX = /\d+\.?\d+\s[A-Za-z]+s\/sec/

  def execute
    `iperf -c #{server} -i 1 --time #{time} > #{INPUT}`
    fail "iperf did exit unsuccessfully." unless $?.success?
    post_process
    @cwb.submit_metrics('bandwidth', OUTPUT)
  end

  def server
    @cwb.deep_fetch('iperf', 'server')
  end

  def time
    @cwb.deep_fetch('iperf', 'time') || 10
  end

  def post_process
    CSV.open(OUTPUT, 'wb') do |csv|
      File.open(INPUT, 'r').each_line do |line|
        csv << [ interval(line), bandwidth(line) ] if bandwidth(line)
      end
    end
  end

  def interval(line)
    line[INTERVAL_REGEX, 1]
  end

  def bandwidth(line)
    line[BANDWIDTH_REGEX]
  end
end
