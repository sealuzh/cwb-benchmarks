require 'cwb'
require 'fileutils'
require_relative("framework")
require_relative("jmh_projects")

class JmhRunner < Cwb::Benchmark

  attr_accessor :trial

  def execute

    puts ">>> Starting JMH benchmarks"
    # @cwb.submit_metric('cpu', timestamp, cpu_model_name) rescue nil

    puts ">>> Setting up defaults"
    set_up_defaults

    projects = config 'jmh-runner', 'projects'

    puts ">>> We have #{projects.size} projects to run benchmarks for"

    projects.each {|project| execute_project(project['project']) }

    puts ">>> Finished all JMH projects"
  rescue => error
      @cwb.notify_failed_execution(error.message)
      raise error
  end

  private

  def execute_project(project)

    puts ">>> Config:"
    puts project

    backend = project['backend']
    group = project['github']['group']
    name = project['github']['name']
    version = project['version'] || "LATEST"
    gradle_build_dir = project['gradle']['build_dir'] if project['gradle']
    gradle_build_cmd = project['gradle']['build_cmd'] if project['gradle']
    jmh_jar = project['jmh_jar']
    mvn_perf_dir = project['mvn']['perf_test_dir'] if project['mvn']
    benchmarks = project['benchmarks']
    params = project['params'] if project['params']
    skip_checkout = true?(project['skip_checkout'])
    skip_compile = true?(project['skip_build'])
    skip_benchmarks = project['skip_benchmarks']

    puts ">>> Starting project #{name}"

    project = case backend
      when 'gradle'
        GradleProject.new(group, name, gradle_build_dir, gradle_build_cmd, jmh_jar, version)
      when 'mvn'
        MvnProject.new(group, name, mvn_perf_dir, jmh_jar, version)
      else
        raise "Unsupported backend " + backend
      end

    project.benchmarks = benchmarks if benchmarks
    project.params = params.map{|param| param['param']} if params

    experiment = Experiment.new
    experiment.project = project
    experiment.skip_checkout = skip_checkout
    experiment.skip_compile = skip_compile
    experiment.skip_benchmarks = skip_benchmarks if (skip_benchmarks && skip_benchmarks.size > 0)

    # this starts the actual benchmark run
    outcome = experiment.run_experiment

    outcome.exectimes.each do |fork, duration|
      # @cwb.submit_metric('Duration', fork, duration)
      @cwb.submit_metric('Duration', @trial, duration)
    end

    outcome.forks.each do |fork, forkresults|
      forkresults.each do |benchmark, bmresults|
        bmresults.each do |individual_value|
          # @cwb.submit_metric(benchmark, fork, individual_value)
          @cwb.submit_metric(benchmark, @trial, individual_value)
        end
      end
    end

    puts ">>> Finished project #{name}"

  end

  def timestamp
    Time.now.to_i
  end

  def cpu_model_name
    @cwb.deep_fetch('cpu', '0', 'model_name')
  end

  def set_up_defaults
    JavaProject.class_variable_set(:@@java,
      @cwb.deep_fetch('jmh-runner', 'env', 'java'))
    JavaProject.class_variable_set(:@@tmp_file,
      @cwb.deep_fetch('jmh-runner', 'env', 'tmp_file_name'))
    JavaProject.class_variable_set(:@@jmh_config,
      @cwb.deep_fetch('jmh-runner', 'bmconfig', 'tool_forks'))
    JavaProject.class_variable_set(:@@jmh_config,
      @cwb.deep_fetch('jmh-runner', 'bmconfig', 'jmh_config'))
    JavaProject.class_variable_set(:@@basedir,
      @cwb.deep_fetch('jmh-runner', 'env', 'basedir'))
    MvnProject.class_variable_set(:@@mvn,
      @cwb.deep_fetch('jmh-runner', 'env', 'mvn'))
    MvnProject.class_variable_set(:@@compile,
      @cwb.deep_fetch('jmh-runner', 'env', 'mvn_compile'))
    GradleProject.class_variable_set(:@@gradle,
      @cwb.deep_fetch('jmh-runner', 'env', 'gradle'))
  end

  def config(*keys)
    tmp = @cwb.deep_fetch *keys
    tmp == '' ? nil : tmp
  end

  def true?(str)
    str == 'true'
  end

end
