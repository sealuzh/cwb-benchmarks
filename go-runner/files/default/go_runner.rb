require 'cwb'
require 'fileutils'
require 'open3'

class GoRunner < Cwb::Benchmark

  attr_accessor :trial

  def execute

    puts ">>> Starting benchmarks"
    # @cwb.submit_metric('cpu', timestamp, cpu_model_name) rescue nil

    projects = config 'go-runner', 'projects'

    puts ">>> We have #{projects.size} projects to run benchmarks for"

    projects.each {|project| execute_project(project['project']) }

    puts ">>> Finished all projects"
    @cwb.notify_finished_execution
  rescue => error
    @cwb.notify_failed_execution(error.message)
    raise error
  end

  private

  def execute_project(project)

    puts ">>> Config:"
    puts project

    group = project['github']['group']
    name = project['github']['name']
    benchmarks = project['benchmarks']

    # create goptc config file
    home_dir = @cwb.deep_fetch('go-runner', 'env', 'basedir')
    in_file_path = "%s/%s-%s-in.json" % [home_dir, group, name]
    puts "Create input file: #{in_file_path}"

    go_path = "%s/%s" % [@cwb.deep_fetch('go-runner', 'env', 'go-own-path'), name]
    project_dir = "%s/src/github.com/%s/%s" % [go_path, group, name]

    bench_regex = benchmarks ? benchmarks : ""

    clear_folder = project['clear_folder']
    clear_folder = "" unless clear_folder

    tool_forks = @cwb.deep_fetch('go-runner', 'bmconfig', 'tool_forks')
    tool_forks = 1 unless tool_forks

    f = File.open(in_file_path, "w+") do |file|
      content = <<-EOT
        {
          "project": "#{project_dir}",
          "dynamic": {
            "i": #{@cwb.deep_fetch('go-runner', 'bmconfig', 'i')},
            "bench_regex": "#{bench_regex}",
            "runs": #{tool_forks}
          },
          "clear": "#{clear_folder}"
        }
      EOT
      file.write(content)
    end

    puts ">>> Starting project #{name}"

    out_file_path = "%s/%s-%s-out.csv" % [home_dir, group, name]

    cmd = "PATH=$PATH:/usr/local/go/bin:#{@cwb.deep_fetch('go-runner', 'env', 'go')}/bin GOPATH=#{go_path} goptc -c #{in_file_path} -o #{out_file_path} -d"
    stdout, stderr, status = Open3.capture3(cmd)
    if !status.success?
      out = "goptc returned with error (%s)\n" % status
      binding.pry
      out << "---------- stderr ----------\n" << stderr
      out << "---------- stdout ----------\n" << stdout
      raise "goptc execution error:\n%s" % out
    end

    printStdout = false || @cwb.deep_fetch('go-runner', 'env', 'print-stdout')
    if printStdout
      puts stdout
    end
     
    o = File.open(out_file_path).each do |l|
      lineArr = l.split(';')
      bench = lineArr[2]
      val = lineArr[3]
      @cwb.submit_metric(bench, @trial, val)
      if printStdout
        puts "submit_metric(%s,%s,%s)" % [bench, @trial, val]
      end
    end

    puts ">>> Finished project #{name}"

    # remove config file
    FileUtils.rm in_file_path
    FileUtils.rm out_file_path
  end

  def config(*keys)
    tmp = @cwb.deep_fetch *keys
    tmp == '' ? nil : tmp
  end
end
