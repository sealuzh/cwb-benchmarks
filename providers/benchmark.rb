def whyrun_supported?
  true
end

def load_current_resource
  @current_resource = Chef::Resource::CwbBenchmark.new(new_resource.name.to_s)
  init_attributes("cookbook", "source")
  @benchmark_util = Cwb::BenchmarkUtil.new(new_resource.name.to_s, node)
end

# Equivalent to :create and :add
action :install do
  cwb_benchmark @benchmark_util.name do
    action :create
  end

  cwb_benchmark @benchmark_util.name do
    action :add
  end
end

# Create the benchmark directory structure and files
action :create do
  directory @benchmark_util.path do
    cwb_defaults(self)
    action :create
  end

  cookbook_file @benchmark_util.class_file do
    cwb_defaults(self)
    cookbook new_resource.cookbook_name.to_s
    source new_resource.source if new_resource.source
    action :create
  end
end

# Add the benchmark to the execution list
action :add do
  benchmarks_list = ::File.read(@benchmark_util.benchmarks_file) rescue ''
  benchmark_util = @benchmark_util
  file @benchmark_util.benchmarks_file do
    cwb_defaults(self)
    content "#{benchmarks_list}\n#{benchmark_util.name}"
    action :create
  end
end

# Removes the benchmark directory structure and files
action :delete do
  cwb_benchmark @benchmark_util.name do
    action :remove
  end

  directory @benchmark_util.path do
    action :delete
  end
end

# Removes the benchmark from the execution list
action :remove do
  benchmarks_list = ::File.read(@benchmark_util.benchmarks_file) rescue ''
  benchmark_util = @benchmark_util
  file @benchmark_util.benchmarks_file do
    cwb_defaults(self)
    content benchmarks_list.gsub(benchmark_util.name, '')
    action :create
  end
end

# Remove the benchmarks file
action :cleanup do
  file @benchmark_util.benchmarks_file do
    action :delete
  end
end

### Helpers

# Initializes all attributes passed into this method as String
# The same as: @current_resource.ATTRIBUTE(new_resource.ATTRIBUTE)
# Example: init_attributes("source", "path")
def init_attributes(*attributes)
  attributes.each do |attribute|
    value = new_resource.send(attribute)
    @current_resource.send(attribute, value)
  end
end
