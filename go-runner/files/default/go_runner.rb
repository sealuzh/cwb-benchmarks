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

    puts project_dir
    return

    bench_regex = if benchmarks then benchmarks else ""
    clear_folder = @cwb.deep_fetch('go-runner', 'env', 'clear_folder')
    clear_folder = "" unless clear_folder

    tool_forks = @cwb.deep_fetch('go-runner', 'bmconfig', 'tool_forks')
    tool_forks = 1 unless tool_forks

    f = File.open(in_file_path, "w+") do |f| 
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
      f.write(content)
    end
    f.close

    puts ">>> Starting project #{name}"

    out_file_path = in_file_path = "%s/%s-%s-out.csv" % [home_dir, group, name]

    env = {
      "PATH" => "$PATH:/usr/local/go/bin:#{@cwb.deep_fetch('go-runner', 'env', 'go')}/bin",
      "GOPATH" => "#{go_path}"
    }
    cmd = [
      "goptc",
      "-c #{in_file_path}", 
      "-o #{out_file_path}", 
      "-d"
    ]
    stdout, stderr, status = Open3.capture3(env, cmd)
    if !status.success?
      puts "goptc was no success: %s" % status
      return
    elsif stderr != ""
      puts "goptc has stderr: %s" % stderr
      return
    end
    
    # do not care about stdout now. could parse the execution time in the future
     
    o = File.open(out_file_path).each do |l|
      lineArr = l.split(';')
      bench = lineArr[2]
      val = lineArr[3]
      @cwb.submit_metric(bench, @trial, val)
    end

    puts ">>> Finished project #{name}"

    # remove config file
    #FileUtils.rm f
    #FileUtils.rm 0
  end
end

  def config(*keys)
    tmp = @cwb.deep_fetch *keys
    tmp == '' ? nil : tmp
  end
end
