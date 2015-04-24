require_relative 'util'

# TODO: document this monkypatching in the README
require_relative 'inflection'
String.send(:include, Inflection)

module Cwb
  class BenchmarkUtil < Util
    attr_reader :name

    def initialize(name, node)
      super(node)
      @name = name
    end

    # Path of the given benchmark
    def path
      File.join(base_dir, name)
    end

    # Returns the path for a file belonging to this benchmark
    def path_for(file_name)
      File.join(path, file_name)
    end

    # Path of the benchmark Ruby class file implementing the benchmark
    def class_file
      path_for(class_file_name)
    end

    # Name of the Ruby benchmark class file
    def class_file_name
      "#{@name.underscore}.rb"
    end

    # Name of the Ruby benchmark class
    # NOTE: the implementation of camelize doesn't detect abbreviations.
    # Therefore, you have to use strict camelization.
    # Example: HttpBenchmark instead of HTTPBenchmark
    def class_name
      @name.camelize
    end
  end
end
