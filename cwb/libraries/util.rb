module Cwb
  class Util
    DEFAULT_BENCHMARK_DIR = '/usr/local/etc/' unless defined? DEFAULT_BENCHMARK_DIR

    # Directory wherein all benchmarks reside (currently the parent directory of path)
    def self.base_dir(node)
      node['cwb']['base_dir']
    rescue
      Chef::Log.warn("No 'cwb.base_dir' specified. Using: #{DEFAULT_BENCHMARK_DIR}")
      DEFAULT_BENCHMARK_DIR
    end

    # Configuration file for the cwb client utility
    def self.config_file(node)
      File.join(self.base_dir(node), 'node.yml')
    end

    def self.base_path_for(file, node)
      File.join(self.base_dir(node), file)
    end

    def initialize(node)
      @node = node
    end

      # See class method
    def base_dir
      self.class.base_dir(@node)
    end

    # See class method
    def config_file
      self.class.config_file(@node)
    end

    # Path to the file that determines the benchmarks to be executed and its order
    def benchmarks_file
      File.join(base_dir, 'benchmarks.txt')
    end

    # Path to the file that determies the benchmark suite to be executed
    def benchmark_suite_file
      File.join(base_dir, 'benchmark_suite.txt')
    end
  end
end
