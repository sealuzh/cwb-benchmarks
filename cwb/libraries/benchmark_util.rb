require_relative 'util'

require_relative 'inflection'
String.send(:include, Inflection)

module Cwb
  class BenchmarkUtil < Util
    attr_reader :name

    def initialize(name, node)
      super(node)
      @name = name
    end

    # @return [String] the path of the given benchmark
    def path
      File.join(base_dir, name)
    end

    # @return [String] the path for a file belonging to this benchmark
    def path_for(file_name)
      File.join(path, file_name)
    end

    # @return [String] the path of the benchmark Ruby class file implementing the benchmark
    def class_file
      path_for(class_file_name)
    end

    # @return [String] the name of the Ruby benchmark class file
    def class_file_name
      "#{@name.underscore}.rb"
    end

    # @return [String] the name of the Ruby benchmark class
    # @note the implementation of camelize doesn't detect abbreviations.
    # Therefore, you have to use strict camelization.
    # Example: HttpBenchmark instead of HTTPBenchmark
    def class_name
      @name.camelize
    end
  end
end
