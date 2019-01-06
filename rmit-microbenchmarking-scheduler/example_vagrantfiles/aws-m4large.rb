# The following variables are available
# benchmark_name: Name of the benchmark definition from the web interface
# benchmark_name_sanitized: benchmark_name where all non-word-characters are replaced with an underscore '_'
# benchmark_id: The unique benchmark definition identifier
# execution_id: The unique benchmark execution identifier
# chef_node_name: The default node name used for Chef client provisioning
# tag_name: The default tag name set as aws name tag

SSH_USERNAME = 'ubuntu'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.username = SSH_USERNAME

  config.vm.provider :aws do |aws, override|
    aws.region = 'us-east-1'
    # Official Ubuntu 14.04 LTS (pv:ebs) image for eu-west-1 from Canonical:
    #  https://cloud-images.ubuntu.com/locator/ec2/
    aws.ami = 'ami-a60c23b0'  # Ubuntu 17.04 with EBS backing and HVM virt
    aws.instance_type = 'm4.large'
    aws.security_groups = ['cwb-web']
  end

  config.vm.provision 'cwb', type: 'chef_client' do |chef|
    chef.add_recipe 'rmit-microbenchmarking-scheduler'  # Version is optional
    chef.json =
    {
      'benchmark' =>  {
          'ssh_username' => SSH_USERNAME,
      },
      'rmit-microbenchmarking-scheduler' => {
        'trials' => '10'
      },      
      'jmh-runner' => {
        'projects' => [
          {
            'project' => {
              'github' => {
                'group' => 'ReactiveX',
                'name' => 'RxJava'
              },
              'skip_checkout' => 'true', # happens as part of the chef run
              'skip_build' => 'true', # happens as part of the chef run              
              'version' => '2162d6d35a8e162f408e1bfd4083924c0987751b',
              'backend' => 'gradle',
              'benchmarks' => 'serializedTwoStreamsSlightlyContended|rx.operators.FlatMapAsFilterPerf.rangeEmptyConcatMap',
              'params' => [
                {'param' => 'size=1000,'},
                {'param' => 'count=1000,'},
                {'param' => 'mask=3,'}
              ],
              'gradle' => {
                  'build_cmd' => 'clean build -x test -x findbugsMain',
                  'build_dir' => 'build'
              },
              'jmh_jar' => 'libs/rxjava-1.2.10-SNAPSHOT-benchmarks.jar'
            },
          },
          {
            'project' => {
              'github' => {
                'group' => 'ReactiveX',
                'name' => 'RxJava'
              },
              'skip_checkout' => 'true', # happens as part of the chef run
              'skip_build' => 'true', # happens as part of the chef run              
              'version' => '2162d6d35a8e162f408e1bfd4083924c0987751b',
              'backend' => 'gradle',
              'benchmarks' => 'OperatorPublishPerf.benchmark',
              'params' => [
                {'param' => 'async=false,'},
                {'param' => 'batchFrequency=4,'},
                {'param' => 'childCount=5,'},
                {'param' => 'size=1000000,'}
              ],
              'gradle' => {
                  'build_cmd' => 'clean build -x test -x findbugsMain',
                  'build_dir' => 'build'
              },
              'jmh_jar' => 'libs/rxjava-1.2.10-SNAPSHOT-benchmarks.jar'
            },
          },
          {
            'project' => {
              'github' => {
                'group' => 'ReactiveX',
                'name' => 'RxJava'
              },
              'skip_checkout' => 'true', # happens as part of the chef run
              'skip_build' => 'true', # happens as part of the chef run              
              'version' => '2162d6d35a8e162f408e1bfd4083924c0987751b',
              'backend' => 'gradle',
              'benchmarks' => 'OperatorPublishPerf.benchmark',
              'params' => [
                {'param' => 'async=false,'},
                {'param' => 'batchFrequency=8,'},
                {'param' => 'childCount=0,'},
                {'param' => 'size=1,'}
              ],
              'gradle' => {
                  'build_cmd' => 'clean build -x test -x findbugsMain',
                  'build_dir' => 'build'
              },
              'jmh_jar' => 'libs/rxjava-1.2.10-SNAPSHOT-benchmarks.jar'
            },
          },
          {
            'project' => {
              'github' => {
                'group' => 'ReactiveX',
                'name' => 'RxJava'
              },
              'skip_checkout' => 'true', # happens as part of the chef run
              'skip_build' => 'true', # happens as part of the chef run              
              'version' => '2162d6d35a8e162f408e1bfd4083924c0987751b',
              'backend' => 'gradle',
              'benchmarks' => 'ComputationSchedulerPerf.observeOn',
              'params' => [
                {'param' => 'size=100,'}
              ],
              'gradle' => {
                  'build_cmd' => 'clean build -x test -x findbugsMain',
                  'build_dir' => 'build'
              },
              'jmh_jar' => 'libs/rxjava-1.2.10-SNAPSHOT-benchmarks.jar'
            }            
          },
          {
            'project' => {
              'github' => {
                'group' => 'apache',
                'name' => 'logging-log4j2'
              },
              'skip_checkout' => 'true', # happens as part of the chef run
              'skip_build' => 'true', # happens as part of the chef run              
              'version' => '8a10178bc0627c7579f936143104efe0a3e296f5',
              'backend' => 'mvn',
              'benchmarks' => 'SortedArrayVsHashMapBenchmark.getValueHashContextData|PatternLayoutBenchmark.serializableMCNoSpace|ThreadContextBenchmark.legacyInjectWithoutProperties',
              'params' => [
                {'param' => 'count=5,'},
                {'param' => 'length=20,'},
                {'param' => 'threadContextMapAlias=NoGcOpenHash,'}
              ],
              'mvn' => {
                  'perf_test_dir' => 'log4j-perf'
              },
              'jmh_jar' => 'target/benchmarks.jar'
            }            
          },
          {
            'project' => {
              'github' => {
                'group' => 'apache',
                'name' => 'logging-log4j2'
              },
              'skip_checkout' => 'true', # happens as part of the chef run
              'skip_build' => 'true', # happens as part of the chef run              
              'version' => '8a10178bc0627c7579f936143104efe0a3e296f5',
              'backend' => 'mvn',
              'benchmarks' => 'ThreadContextBenchmark.putAndRemove',
              'params' => [
                {'param' => 'count=50,'},
                {'param' => 'threadContextMapAlias=NoGcSortedArray,'}
              ],
              'mvn' => {
                  'perf_test_dir' => 'log4j-perf'
              },
              'jmh_jar' => 'target/benchmarks.jar'
            }            
          }, 
          {
            'project' => {
              'github' => {
                'group' => 'apache',
                'name' => 'logging-log4j2'
              },
              'skip_checkout' => 'true', # happens as part of the chef run
              'skip_build' => 'true', # happens as part of the chef run              
              'version' => '8a10178bc0627c7579f936143104efe0a3e296f5',
              'backend' => 'mvn',
              'benchmarks' => 'SortedArrayVsHashMapBenchmark.getValueHashContextData',
              'params' => [
                {'param' => 'count=500,'},
                {'param' => 'length=20,'}
              ],
              'mvn' => {
                  'perf_test_dir' => 'log4j-perf'
              },
              'jmh_jar' => 'target/benchmarks.jar'
            }            
          },           
          ],
        'bmconfig' => {
          'tool_forks' => '1',
          'jmh_config' => '-wi 10 -i 50 -f 1 -bm avgt -tu ns'
        }
      },
      'go-runner' => {
        'projects' => [
          {
            'project' => {
              'github' => {
                'group' => 'coreos',
                'name' => 'etcd',
              },
              'version' => 'e7e7451213d32fdea530050446f709ea9db6c2f7',
              'benchmarks': '^BenchmarkManySmallResponseUnmarshal$|^BenchmarkMutex4Waiters$|^BenchmarkMediumResponseUnmarshal$|^BenchmarkStorePut$|^BenchmarkBackendPut$',
              'backend' => 'glide',
              'clear_folder' => '/tmp/',
            }
          },
          {
            'project' => {
              'github' => {
                'group' => 'blevesearch',
                'name' => 'bleve'
              },
              'version' => '0b1034dcbe067789a206f3267f41c6a1f9760b56',
              'benchmarks' => '^BenchmarkTop100of50Scores$|^BenchmarkNullIndexing1Workers10Batch$|^BenchmarkTermFrequencyRowDecode$|^BenchmarkTop1000of100000Scores$|^BenchmarkGoLevelDBIndexing2Workers10Batch$',
              'backend' => 'get',
            }
          }
        ],
        'bmconfig' => {
          'tool_forks' => 1,
          'i' => 50,
        }
    }
  }
  end
end
