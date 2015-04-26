require 'cwb'

# DEPRECATED: Use the new cwb gem instead
class BenchmarkHelper
  @@cwb = Cwb::Client.instance

  # Submit a single metric
  def self.submit_metric(metric_definition_id, time, value)
    @@cwb.submit_metric(metric_definition_id, time, value)
  end

  # Submit a csv file with metrics
  def self.submit_metrics(metric_definition_id, csv_file)
    @@cwb.submit_metrics(metric_definition_id, csv_file)
  end


  ### Notifications to the Cloud-WorkBench

  # Benchmark has been completed and postprocessing will be started immediately
  def self.notify_benchmark_completed_and_continue(success = true, message = '')
    self.notify_benchmark_completed(success, message, continue: true)
  end

  # Benchmark has been completed and postprocessing won't be started now
  # The Cloud-WorkBench starts the postprocessing on the primary machine
  def self.notify_benchmark_completed_and_wait(success = true, message = '')
    self.notify_benchmark_completed(success, message, continue: false)
  end

  def self.notify_benchmark_completed(success = true, message = '', opts = {})
    if success
      warn_unsupported_method
    else
      @@cwb.notify_failed_execution
    end
  end

  # Postprocessing has been completed
  # The Cloud-WorkBench will terminate all instances of this benchmark execution
  def self.notify_postprocessing_completed(success = true, message = '', opts = {})
    if success
      @@cwb.notify_finished_execution
    else
      @@cwb.notify_failed_execution
    end
  end


  private

    def self.print_deprecation_warning
      $stderr.puts 'BenchmarkHelper is DEPRECATED => Use the new cwb gem instead.'
    end

    def self.warn_unsupported_method
      $stderr.puts 'UNSUPPORTED METHOD'
    end

    def self.init
      print_deprecation_warning
      @@cwb = Cwb::Client.instance
      config = Cwb::Config.from_dir('.')
      @@cwb.reconfigure(config)
    end
end

BenchmarkHelper.init
