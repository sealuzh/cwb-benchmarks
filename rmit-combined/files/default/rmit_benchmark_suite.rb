require 'cwb'

module Cwb
  class RmitBenchmarkSuite < Cwb::BenchmarkSuite
    def execute_suite(cwb_benchmarks)
      rmit_benchmarks = rmit_list(cwb_benchmarks)
      @cwb.submit_metric('benchmark-order', timestamp, rmit_benchmarks.map(&:class).to_s)
      @cwb.submit_metric('cpu', timestamp, cpu_model_name) rescue nil
      execute_all(rmit_benchmarks)
      @cwb.notify_finished_execution
    rescue => error
      @cwb.notify_failed_execution(error.message)
      raise error
    end

    private

      # Reorders a list to follow the Randomized Multiple Interleaved Trials (RMIT) methodology
      # described in the paper: Conducting Repeatable Experiments in Highly Variable Cloud Computing Environments
      # A. Abedi and T. Brecht (2017)
      def rmit_list(list)
        repeated_list(list, repetitions).shuffle
      end

      def repeated_list(list, repetitions)
        repeated_list = []
        repetitions.times { repeated_list.concat list }
        repeated_list
      end

      def repetitions
        @cwb.deep_fetch('rmit-combined', 'repetitions')
      end

      def cpu_model_name
        @cwb.deep_fetch('cpu', '0', 'model_name')
      end

      def timestamp
        Time.now.to_i
      end
  end
end
