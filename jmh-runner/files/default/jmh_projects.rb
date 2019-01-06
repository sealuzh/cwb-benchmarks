require("json")
require_relative("framework")
class JavaProject < Project

  @@basedir = "/home/ubuntu"
  @@java = "java"
  @@jmh = "-jar "
  @@jmh_config = "-wi 10 -i 20 -f 1"
  @@tmp_file_config = "-rf json -rff"
  @@tmp_file = "tmp.json"

  attr_accessor :benchmarks
  attr_accessor :params

  def initialize(group, name, perftestrepo, jmh_jar = "target/microbenchmarks.jar", version = "LATEST")
    super(group, name, version)
    @perftestrepo = perftestrepo
    @jmh_jar = jmh_jar
  end

  def perftestdir
    "#{@@basedir}/#{@dir}/#{@perftestrepo}"
  end

  def perftestresultfile
    "#{perftestdir}/#{@@tmp_file}"
  end

  def run_benchmarks
    Dir.chdir(perftestdir) do
      cmd = "%s %s %s " % [@@java, @@jmh, @jmh_jar]
      if @params  # see if we want to provide a custom params string
        puts @params
        @params.each{|param| cmd << "-p " << param << " " }
      end
      cmd << "\"" << @benchmarks << "\" " if @benchmarks  # see if we want to run only a subset of benchmarks
      cmd << "%s %s %s" % [@@jmh_config, @@tmp_file_config, @@tmp_file]
      puts ">>> Running benchmark command #{cmd}"
      system(cmd)
    end
  end

  def load_results
    content = File.read(perftestresultfile)
    json = JSON.parse(content)
    results = {}
    json.each do |benchmark|
      name = benchmark['benchmark']
      if benchmark.include? "params"
        benchmark['params'].each do |key, val|
          name += "(#{key}-#{val})"
        end
      end
      results[name] = benchmark['primaryMetric']['rawData'].flatten
    end
    return results
  end

end

class MvnProject < JavaProject

  @@mvn = "mvn"
  @@compile = "clean install -DskipTests"

  def compile
    cmd = "#{@@mvn} #{@@compile}"
    puts ">>> Compiling project with Mvn command #{cmd}"
    Dir.chdir(@dir){ system(cmd) }
  end

end

class GradleProject < JavaProject

  @@gradle = "./gradlew"

  def initialize(group, name, perftestrepo, gradletarget, jmh_jar = "target/microbenchmarks.jar", version = "LATEST")
    super(group, name, perftestrepo, jmh_jar, version)
    @gradletarget = gradletarget
  end

  def compile
    puts ">>> Compiling project with Gradle"
    Dir.chdir(@dir){ system("#{@@gradle} #{@gradletarget}") }
  end

end
