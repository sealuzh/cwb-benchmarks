module Timeable

  def time
    t1 = Time.now
    yield
    (Time.now - t1) / 60 / 60 # these are secs, convert to hours
  end

end

class Experiment
  include Timeable

  attr_accessor :tests_to_skip
  attr_accessor :skip_checkout
  attr_accessor :skip_compile

  def initialize(forks = 1)
    @forks = forks
    @tests_to_skip = []
    @skip_checkout = false
    @skip_compile = false
  end

  def project=(project)
    @project = project
  end

  def run_experiment

    puts ">>> Starting experiments"
    @project.prepare(tests_to_skip, @skip_checkout, @skip_compile)

    results = Result.new
    @forks.times do |fork|
      puts ">>> Starting fork #{fork}"
      exec_time = time { @project.run_benchmarks }
      results << { :results => @project.load_results, :duration => exec_time }
    end

    return results

  end

  def skip_compile
    @skip_compile = true
  end

  def skip_checkout
    @skip_checkout = true
  end

end

class GHProject

  @@GitHubBaseURL = "https://github.com"

  attr_reader :group
  attr_reader :name

  def initialize(group, name)
    @group = group
    @name = name
  end

  def full_name
    "#{@group}/#{@name}"
  end

  def full_url
    "#{@@GitHubBaseURL}/#{@group}/#{@name}.git"
  end

end

require("git")
require("fileutils")
class Repository

  def initialize(project)
    @project = project
  end

  def clone_repo(version = "LATEST")
    if File.exist? @project.name
      FileUtils.remove_dir(@project.name)
    end
    @git = Git.clone(@project.full_url, @project.name)
    if version != "LATEST"
      @git.checkout(version)
    end
  end

end

require("fileutils")
class Project

  def initialize(group, name, version = "LATEST")
    @repo = Repository.new(GHProject.new(group, name))
    @dir = name
    @version = version
  end

  def prepare(tests_to_skip = [], skip_checkout = false, skip_compile = false)
    @repo.clone_repo(@version) unless skip_checkout
    tests_to_skip.each {|ignore| disable_test(ignore) }
    compile unless skip_compile
  end

  private

  def disable_test(test)
    fqn = "#{@dir}/#{test}"
    FileUtils.mv(fqn, fqn+".disabled")
  end

end

class Result

  attr_reader :forks
  attr_reader :exectimes

  def initialize
    @forks = {}
    @exectimes = {}
  end

  def <<(result)
    key = highest_key+1
    @forks[key] = result[:results]
    @exectimes[key] = result[:duration]
  end

  def to_s
    s = "Experiment Runtime:\n"
    s << to_s_duration << "\n"
    s << "Experiment Results:\n"
    s << to_s_results << "\n"
  end

  def to_s_duration
      @exectimes.values
  end

  def to_s_results
    s = ""
    @forks.each do |fork, forkresults|
      forkresults.each do |benchmark, bmresults|
          bmresults.each do |individual_value|
            s << "%d;%s;%.3f" % [fork, benchmark, individual_value]
          end
      end
    end
    return s
  end

  private

  def highest_key
    if @forks.size > 0
      @forks.keys.max
    else
      -1
    end
  end

end
