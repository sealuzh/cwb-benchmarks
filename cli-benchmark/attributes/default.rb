### Installation attributes

# System packages to be installed as dependencies
default['cli-benchmark']['packages'] = []
# Shell commands that are invoked during the installation,
# after the benchmark is installed
default['cli-benchmark']['install'] = []


### Runtime attributes

# Shell command that is invoked immediately before the actual benchmark runs
default['cli-benchmark']['pre_run'] = nil
# Shell command that runs the actual benchmark
default['cli-benchmark']['run'] = 'date'
# List of metrics to be submitted using regex to capture results from stdout
# @example 'execution_time' => '.*'
default['cli-benchmark']['metrics'] = [ ]
