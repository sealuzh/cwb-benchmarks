### Installation attributes

# System packages to be installed as dependencies
default['cli-benchmark']['packages'] = []
# Shell commands that are invoked during the installation,
# after the benchmark is installed
default['cli-benchmark']['install'] = []


### Runtime attributes

# Shell command that is invoked immediately BEFORE the actual benchmark runs
default['cli-benchmark']['pre_run'] = nil
# Shell command that runs the actual benchmark
default['cli-benchmark']['run'] = 'date'
# Number of times the entire benchmark (including pre_run and post_run is repeated)
default['cli-benchmark']['repetitions'] = 1
# Shell command that is invoked immediately AFTER the actual benchmark runs
default['cli-benchmark']['post_run'] = nil
# List of metrics to be submitted using regex to capture results from stdout
# @example 'execution_time' => '.*'
default['cli-benchmark']['metrics'] = [ ]
