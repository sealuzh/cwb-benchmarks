# Cloud WorkBench Cookbook (CWB Cookbook) 

This cookbook prepares a machine for CWB benchmarks.

## Resource

Use the `cwb_benchmark` resource to define a benchmark. Make sure you place the Ruby implementation of the benchmark within `files/default/benchmark_name.rb`.
Take care of correct naming! Example:
* Cookbook and benchmark name: `http-benchmark` (hyphen)
* Ruby benchmark implementation: `http_benchmark` (underscore)
* Ruby benchmark class name: `HttpBenchmark` (CamelCase => ~~HTTPBenchmark~~ is wrong!)

```ruby
cwb_benchmark 'benchmark-name'
```

## Libraries

### cwb_defaults(self)

Instead of hardcoding `owner` and `group` you should use the `cwb_defaults(self)` utility method:

```ruby
file '/tmp/something' do
  cwb_defaults(self)
  action :create
end
```

### Cwb::BenchmarkUtil

Provides path utilities for your benchmark.

Example usage within your recipe:

```ruby
my_bench = Cwb::BenchmarkUtil.new('benchmark-name', node)
cwb_benchmark my_bench.name

# Create a config file from a template that should reside
# at the same directory as the Ruby benchmark file.
template my_bench.path_for('config.ini') do
  cwb_defaults(self)
  source 'config.ini.erb'
end
```

### Cwb::Util

```ruby
Cwb::Util.root_dir(node)

cwb_util = Cwb::Util.new(node)
cwb_util.root_dir
```

## Usage

### cwb::default

You should not explicitly include the `cwb::default` recipe within your cookbooks. Instead the CWB Server will take care of adding cwb to the Chef run list.

## Internal Structure

The `cwb::core` recipe prepares the following structure for benchmarks that are subsequently added by custom benchmark cookbooks.

```
.
├── benchmark_suite.txt [single benchmark suite to be executed]
├── benchmarks.txt [ordered list of benchmarks to be executed]
├── node.yml [hash of Chef node attributes]
├── app-bench
│   └── app_bench.rb
├── micro-bench
│   └── micro_bench.rb
├── my-bench
│   └── my_bench.rb
│   └── config.ini
```

### cwb CLI

The command line utility is able to execute single benchmarks in isolation or an entire benchmark suite. The default benchmark suite will execute all benchmarks according to the order in `benchmarks.txt` which reflects the recipe order in the Chef run list.

```bash
cwb execute micro-bench/micro_bench.rb
cwb execute .
```

## Notes

* This cookbook monkypatches the String class by adding the utility methods `camelize` and `underscore`. These methods are for internal use, do NOT depend on them.

## License and Authors

Author:: Joel Scheuner (joel.scheuner.dev@gmail.com)
