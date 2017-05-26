require 'cwb'
require_relative("framework")
require_relative("jmh_projects")
require("pry")

class SoftwareMicrobenchmarkingRunner < Cwb::Benchmark
  def execute

    puts "Starting benchmark"
    @cwb.submit_metric('cpu', timestamp, cpu_model_name) rescue nil

    puts "Setting up defaults"
    set_up_defaults

    backend = config 'software-microbenchmarking-runner', 'project', 'backend'
    group = config 'software-microbenchmarking-runner', 'github', 'group'
    name = config 'software-microbenchmarking-runner', 'github', 'name'
    version = config('software-microbenchmarking-runner', 'project', 'version') || "LATEST"
    gradle_build_dir = config 'software-microbenchmarking-runner', 'project', 'gradle', 'build_dir'
    gradle_build_cmd = config 'software-microbenchmarking-runner', 'project', 'gradle', 'build_cmd'
    jmh_jar = config 'software-microbenchmarking-runner', 'project', 'jmh_jar'
    mvn_perf_dir = config 'software-microbenchmarking-runner', 'project', 'mvn', 'perf_test_dir'
    benchmarks = config 'software-microbenchmarking-runner', 'project', 'benchmarks'
    skip_checkout = true?(config('software-microbenchmarking-runner', 'project', 'skip_checkout'))
    skip_compile = true?(config('software-microbenchmarking-runner', 'project', 'skip_build'))
    skip_benchmarks = config 'software-microbenchmarking-runner', 'project', 'skip_benchmarks'
    tool_forks = config('software-microbenchmarking-runner', 'bmconfig', 'tool_forks').to_i

    project = case backend
      when 'gradle'
        GradleProject.new(group, name, gradle_build_dir, gradle_build_cmd, jmh_jar, version)
      when 'mvn'
        MvnProject.new(group, name, mvn_perf_dir, jmh_jar, version)
      else
        raise "Unsupported backend " + backend
      end

    project.benchmarks = benchmarks if benchmarks

    experiment = Experiment.new(tool_forks)
    experiment.project = project
    experiment.skip_checkout = skip_checkout
    experiment.skip_compile = skip_compile
    experiment.skip_benchmarks = skip_benchmarks if (skip_benchmarks && skip_benchmarks.size > 0)

    # this starts the actual benchmark run
    outcome = experiment.run_experiment

    outcome.exectimes.each do |fork, duration|
      @cwb.submit_metric('Duration', fork, duration)
    end

    outcome.forks.each do |fork, forkresults|
      forkresults.each do |benchmark, bmresults|
        bmresults.each do |individual_value|
          @cwb.submit_metric(benchmark, fork, individual_value)
        end
      end
    end
    puts "Finished benchmark"
  end

  private

  def timestamp
    Time.now.to_i
  end

  def cpu_model_name
    @cwb.deep_fetch('cpu', '0', 'model_name')
  end

  def set_up_defaults
    JavaProject.class_variable_set(:@@java,
      @cwb.deep_fetch('software-microbenchmarking-runner', 'env', 'java'))
    JavaProject.class_variable_set(:@@tmp_file,
      @cwb.deep_fetch('software-microbenchmarking-runner', 'env', 'tmp_file_name'))
    JavaProject.class_variable_set(:@@jmh_config,
      @cwb.deep_fetch('software-microbenchmarking-runner', 'bmconfig', 'jmh_config'))
    MvnProject.class_variable_set(:@@mvn,
      @cwb.deep_fetch('software-microbenchmarking-runner', 'env', 'mvn'))
    MvnProject.class_variable_set(:@@compile,
      @cwb.deep_fetch('software-microbenchmarking-runner', 'env', 'mvn_compile'))
    GradleProject.class_variable_set(:@@gradle,
      @cwb.deep_fetch('software-microbenchmarking-runner', 'env', 'gradle'))
  end

  def config(*keys)
    tmp = @cwb.deep_fetch *keys
    tmp == '' ? nil : tmp
  end

  def true?(str)
    str == 'true'
  end

end
