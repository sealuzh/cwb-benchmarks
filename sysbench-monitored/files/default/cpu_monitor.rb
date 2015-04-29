require_relative 'sar_parser'

class CpuMonitor
  SAR_OUT = 'sar.out'
  SAR_PID = 'sar.pid'
  SAR_TXT = 'sar.txt'

  # HACK: Practically forever (~30 years if interval=1)
  NUM_TIMES = 10**9

  # @param interval in seconds
  # @note sar spawns out new sadc processes
  # that may remain running after interrupting sar
  # `ps aux` contains: sadc 1000000000 -z -S XALL sar.out
  # Workaround could be: `pkill sadc`
  def start(interval)
    start_plain_text(interval)
  end

  def start_plain_text(interval)
    %x[ sar #{interval} #{NUM_TIMES} >#{SAR_TXT} 2>&1 </dev/null & echo $! > #{SAR_PID} ]
  end

  def start_binary(interval)
    %x[ sar -o #{SAR_OUT} #{interval} #{NUM_TIMES} >/dev/null 2>&1 </dev/null & echo $! > #{SAR_PID} ]
  end

  def stop
    %x[ sudo kill `cat #{SAR_PID}` ]
  end

  def postprocess
    # format_sar
    sar_parser = SarParser.new(SAR_TXT)
    sar_parser.write_to_csv(user_file, UserSarParser.new)
    sar_parser.write_to_csv(steal_file, StealSarParser.new)
    sar_parser.write_to_csv(idle_file, IdleSarParser.new)
  end

  # Parses the binary sar output afterwards if
  # sar was used with the -o SAR_OUT option
  def format_sar
    %x[ sar -f #{SAR_OUT} > #{SAR_TXT} ]
  end

  def user_file
    'sar_user.csv'
  end

  def steal_file
    'sar_steal.csv'
  end

  def idle_file
    'sar_idle.csv'
  end
end
