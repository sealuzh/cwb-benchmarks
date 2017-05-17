require 'cwb'
require 'open3'

module Cwb
  # Parent class: https://github.com/sealuzh/cwb/blob/master/lib/cwb/benchmark_suite.rb
  class RmitBenchmarkSuite < Cwb::BenchmarkSuite
    def execute_suite(cwb_benchmarks)
      submit_global_metrics
      filtered_benchmarks = filtered_list(cwb_benchmarks)
      rmit_benchmarks = rmit_list(filtered_benchmarks, repetitions)
      @cwb.submit_metric('benchmark/order', timestamp, rmit_benchmarks.map(&:class).to_s)
      execute_all(rmit_benchmarks)
      @cwb.notify_finished_execution
    rescue => error
      @cwb.notify_failed_execution(error.message)
      raise error
    end

    def execute_all(cwb_benchmarks)
      cwb_benchmarks.each do |cwb_benchmark|
        execute_single(cwb_benchmark)
      end
    end

    def execute_single(cwb_benchmark)
      @cwb.submit_metric('benchmark/execution-log', timestamp, "#{cwb_benchmark.class}_START")
      cwb_benchmark.execute_in_working_dir
      @cwb.submit_metric('benchmark/execution-log', timestamp, "#{cwb_benchmark.class}_END")
      sleep inter_benchmark_sleep
    end

    def submit_global_metrics
      @cwb.submit_metric('instance/cpu-model', timestamp, cpu_model_name)
      @cwb.submit_metric('instance/cpu-cores', timestamp, cpu_cores)
      @cwb.submit_metric('instance/ram-total', timestamp, node_ram_in_kB)
      @cwb.submit_metric('instance/gcc-version', timestamp, `gcc --version | head -n 1`.strip)
      @cwb.submit_metric('sysbench/version', timestamp, `sysbench --version`.strip)
      @cwb.submit_metric('fio/version', timestamp, `fio --version`.strip)
      @cwb.submit_metric('stressng/version', timestamp, `stress-ng --version`.strip)
      @cwb.submit_metric('iperf/version', timestamp, Open3.capture3('iperf --version')[1].strip)
    end

    private

      def filtered_list(list)
        filtered_v1 = include_filter(list)
        filtered_v2 = exclude_filter(filtered_v1)
        filtered_v2
      end

      def include_filter(list)
        include_list = parse_flag_list(includes)
        if include_list.empty?
          list
        else
          list.select { |item| include_list.include?(item.class.to_s) }
        end
      end

      def exclude_filter(list)
        exclude_list = parse_flag_list(excludes)
        if exclude_list.empty?
          list
        else
          list.select { |item| !exclude_list.include?(item.class.to_s) }
        end
      end

      # Reorders a list to follow the Randomized Multiple Interleaved Trials (RMIT) methodology
      # described in the paper: Conducting Repeatable Experiments in Highly Variable Cloud Computing Environments
      # A. Abedi and T. Brecht (2017)
      def rmit_list(list, repetitions)
        rmit_list = []
        repetitions.times { rmit_list.concat list.shuffle }
        rmit_list
      end

      def includes
        @cwb.deep_fetch('rmit-combined', 'includes')
      end

      def excludes
        @cwb.deep_fetch('rmit-combined', 'excludes')
      end

      # Example: parse_flag_list({'SysbenchCpu' => true, 'Wordpress-Bench' => false}) = ['SysbenchCpu']
      def parse_flag_list(flag_set)
        list = []
        flag_set.each do |key, flag|
          list << key if flag
        end
        list
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
