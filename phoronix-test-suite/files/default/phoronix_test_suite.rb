require 'cwb'

class PhoronixTestSuite < Cwb::Benchmark
  def execute
    @cwb.submit_metric('cpu', timestamp, cpu_model_name) rescue nil

    all_tests.each do |test, metrics|
      stdout = `phoronix-test-suite batch-run #{test}`
      metrics.each do |name, regex|
        result = stdout[/#{regex}/, 1]
        @cwb.submit_metric(name, timestamp, result)
      end
    end
  end

  def timestamp
    Time.now.to_i
  end

  def cpu_model_name
    @cwb.deep_fetch('cpu', '0', 'model_name')
  end

  def all_tests
    @cwb.deep_fetch('phoronix-test-suite', 'tests')
  end
end
