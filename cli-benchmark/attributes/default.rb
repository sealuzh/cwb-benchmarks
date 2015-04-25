### Installation attributes

# System packages to be installed as dependencies
default['cli-benchmark']['packages'] = []
# Shell command that is in invoked during the installation,
# after the benchmark is installed
default['cli-benchmark']['install'] = nil


### Runtime attributes

# Shell command that is invoked immediately before the actual benchmark runs
default['cli-benchmark']['pre_run'] = nil
# Shell command that runs the actual benchmark
default['cli-benchmark']['run'] = 'date'
# Regex that extracts the resulting metric from stdout of the command
default['cli-benchmark']['regex'] = '.*'
# Name of the resulting metric
default['cli-benchmark']['metric'] = 'time'
