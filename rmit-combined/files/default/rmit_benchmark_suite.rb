require 'cwb'
require 'open3'

module Cwb
  # Parent class: https://github.com/sealuzh/cwb/blob/master/lib/cwb/benchmark_suite.rb
  class RmitBenchmarkSuite < Cwb::BenchmarkSuite
    def execute_suite(cwb_benchmarks)
      submit_global_metrics
      rmit_benchmarks = rmit_list(cwb_benchmarks)
      @cwb.submit_metric('benchmark-order', timestamp, rmit_benchmarks.map(&:class).to_s)
      execute_all(rmit_benchmarks)
      @cwb.notify_finished_execution
    rescue => error
      @cwb.notify_failed_execution(error.message)
      raise error
    end

    def execute_all(cwb_benchmarks)
      cwb_benchmarks.each do |cwb_benchmark|
        cwb_benchmark.execute_in_working_dir
        sleep inter_benchmark_sleep
      end
    end

    def submit_global_metrics
      @cwb.submit_metric('cpu-model', timestamp, cpu_model_name)
      @cwb.submit_metric('cpu-cores', timestamp, cpu_cores)
      @cwb.submit_metric('ram-total', timestamp, node_ram_in_kB)
      @cwb.submit_metric('gcc-version', timestamp, `gcc --version | head -n 1`)
      @cwb.submit_metric('sysbench/version', timestamp, `sysbench --version`)
      @cwb.submit_metric('fio/version', timestamp, `fio --version`)
      @cwb.submit_metric('stressng/version', timestamp, `stress-ng --version`)
      @cwb.submit_metric('iperf/version', timestamp, Open3.capture3('iperf --version')[1])
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

      def inter_benchmark_sleep
        @cwb.deep_fetch('rmit-combined', 'inter_benchmark_sleep')
      end

      def cpu_model_name
        @cwb.deep_fetch('cpu', '0', 'model_name')
      end

      def cpu_cores
        @cwb.deep_fetch('cpu', '0', 'cores')
      end

      def node_ram_in_kB
        @cwb.deep_fetch('memory', 'total')
      end

      def timestamp
        Time.now.to_i
      end
  end
end
