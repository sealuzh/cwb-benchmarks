require 'cwb'

class RmitMicrobenchmarkingScheduler < Cwb::Benchmark

  def execute_suite(cwb_benchmarks)

    puts ">>> Starting suite of #{cwb_benchmarks.size} benchmarks"
    submit_global_metrics
    trials = (config 'rmit-microbenchmarking-scheduler', 'trials').to_i
    puts ">>> Scheduling #{trials} trials"
    execution_plan = rmit_list(cwb_benchmarks, trials)
    puts ">>> Execution plan:"
    execution_plan.each{|pair| puts pair[:benchmark].class.to_s }
    puts ">>> Starting benchmarks"
    execution_plan.each do |pair|
      execute(pair[:benchmark], pair[:trial])
    end
    @cwb.notify_finished_execution

  rescue => error
    @cwb.notify_failed_execution(error.message)
    raise error

  end

  private

  def execute(benchmark, trial)
    puts ">>> Starting #{benchmark.class.to_s} in trial #{trial}"
    benchmark.trial = trial
    benchmark.execute_in_working_dir
  end

  # Reorders a list to follow the Randomized Multiple Interleaved Trials (RMIT) methodology
  # described in the paper: Conducting Repeatable Experiments in Highly Variable Cloud Computing Environments
  # A. Abedi and T. Brecht (2017)
  def rmit_list(list, trials)
    rmit_list = []
    trials.times do |i|
      l = list.shuffle
      l.each do |bm|
        rmit_list << {trial: i+1, benchmark: bm}
      end
    end
    rmit_list
  end

  def submit_global_metrics
    @cwb.submit_metric('instance/cpu-model', timestamp, cpu_model_name)
    @cwb.submit_metric('instance/cpu-cores', timestamp, num_cpu_cores)
    @cwb.submit_metric('instance/ram-total', timestamp, node_ram_in_kB)
  end

  def cpu_model_name
    @cwb.deep_fetch('cpu', '0', 'model_name')
  end

  def num_cpu_cores
    @cwb.deep_fetch('cpu', 'total')
  end

  def node_ram_in_kB
    @cwb.deep_fetch('memory', 'total')
  end

  def config(*keys)
    tmp = @cwb.deep_fetch *keys
    tmp == '' ? nil : tmp
  end

  def timestamp
    Time.now.to_i
  end

end
