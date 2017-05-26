# default['benchmark-name']['metric_name'] = 'execution_time'

# benchmark setup - this is what you will need to set up for most tests
# some of these are sensible defaults, but many of these settings need to be changed
default['software-microbenchmarking-runner']['github']['group'] = 'ReactiveX'
default['software-microbenchmarking-runner']['github']['name'] = 'RxJava'
default['software-microbenchmarking-runner']['project']['skip_checkout'] = 'false'
default['software-microbenchmarking-runner']['project']['skip_build'] = 'false'
default['software-microbenchmarking-runner']['project']['jmh_jar'] = 'libs/rxjava-1.2.10-SNAPSHOT-benchmarks.jar'
default['software-microbenchmarking-runner']['project']['backend'] = 'gradle'
default['software-microbenchmarking-runner']['project']['version'] = nil # defaults to Latest
default['software-microbenchmarking-runner']['project']['benchmarks'] = nil # defaults to all benchmarks
default['software-microbenchmarking-runner']['project']['skip_benchmarks'] = nil # defaults to all benchmarks
default['software-microbenchmarking-runner']['project']['mvn']['perf_test_dir'] = 'perf'
default['software-microbenchmarking-runner']['project']['gradle']['build_cmd'] = 'clean build -x test'
default['software-microbenchmarking-runner']['project']['gradle']['build_dir'] = 'build'

# benchmark config - these are the defaults, but we can override them
default['software-microbenchmarking-runner']['bmconfig']['tool_forks'] = '1'
default['software-microbenchmarking-runner']['bmconfig']['jmh_config'] = '-wi 10 -i 20 -f 1'

# environment setup - you should not need to change those, but you can
default['software-microbenchmarking-runner']['env']['java'] = 'java'
default['software-microbenchmarking-runner']['env']['mvn'] = 'mvn'
default['software-microbenchmarking-runner']['env']['gradle'] = './gradlew'
default['software-microbenchmarking-runner']['env']['mvn_compile'] = 'clean install -DskipTests'
default['software-microbenchmarking-runner']['env']['tmp_file_name'] = 'tmp.json'
