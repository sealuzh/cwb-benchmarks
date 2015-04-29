require 'cwb'
require_relative '../sysbench/sysbench.rb'
require_relative 'cpu_monitor'

class SysbenchMonitored < Sysbench
  def execute
    @cwb.submit_metric(cpu_metric, timestamp, cpu_model_name)
    cpu_monitor = CpuMonitor.new
    cpu_monitor.start(sar_interval)
    sleep(sleeptime)
    start = Time.now
    while elapsed_time(start) < runtime do
      execution_time = extract_time(run_sysbench)
      @cwb.submit_metric(execution_time_metric, timestamp, execution_time)
    end
    sleep(sleeptime)
    cpu_monitor.stop
    submit_monitored_metrics(cpu_monitor)
  end

  def elapsed_time(start)
    Time.now - start
  end

  def runtime
    @cwb.deep_fetch('sysbench-monitored', 'runtime').to_i
  end

  def sar_interval
    @cwb.deep_fetch('sysbench-monitored', 'sar_interval')
  end

  def sleeptime
    @cwb.deep_fetch('sysbench-monitored', 'sleeptime')
  end

  def submit_monitored_metrics(cpu_monitor)
    cpu_monitor.postprocess
    @cwb.submit_metrics('sar_user', cpu_monitor.user_file)
    @cwb.submit_metrics('sar_steal', cpu_monitor.steal_file)
    @cwb.submit_metrics('sar_idle', cpu_monitor.idle_file)
  end
end
