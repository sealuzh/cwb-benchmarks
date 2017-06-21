# default['benchmark-name']['metric_name'] = 'execution_time'

# benchmark setup - this is what you will need to set up for most tests
# some of these are sensible defaults, but many of these settings need to be changed
default['jmh-runner']['projects'][0]['project']['github']['group'] = 'ReactiveX'
default['jmh-runner']['projects'][0]['project']['github']['name'] = 'RxJava'
default['jmh-runner']['projects'][0]['project']['skip_checkout'] = 'false'
default['jmh-runner']['projects'][0]['project']['skip_build'] = 'false'
default['jmh-runner']['projects'][0]['project']['jmh_jar'] = 'libs/rxjava-1.2.10-SNAPSHOT-benchmarks.jar'
default['jmh-runner']['projects'][0]['project']['backend'] = 'gradle'
default['jmh-runner']['projects'][0]['project']['version'] = nil # defaults to Latest
default['jmh-runner']['projects'][0]['project']['benchmarks'] = nil # defaults to all benchmarks
default['jmh-runner']['projects'][0]['project']['skip_benchmarks'] = nil # defaults to all benchmarks
default['jmh-runner']['projects'][0]['project']['mvn']['perf_test_dir'] = 'perf'
default['jmh-runner']['projects'][0]['project']['gradle']['build_cmd'] = 'clean build -x test'
default['jmh-runner']['projects'][0]['project']['gradle']['build_dir'] = 'build'

# benchmark config - these are the defaults, but we can override them
default['jmh-runner']['bmconfig']['tool_forks'] = '1'
default['jmh-runner']['bmconfig']['jmh_config'] = '-wi 10 -i 20 -f 1'

# environment setup - you should not need to change those, but you can
default['jmh-runner']['env']['java'] = 'java'
default['jmh-runner']['env']['mvn'] = 'mvn'
default['jmh-runner']['env']['gradle'] = './gradlew'
default['jmh-runner']['env']['mvn_compile'] = 'clean install -DskipTests'
default['jmh-runner']['env']['tmp_file_name'] = 'tmp.json'
