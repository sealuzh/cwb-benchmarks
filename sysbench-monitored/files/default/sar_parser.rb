require 'time'
require 'date'
require 'csv'

# @todo Take a look at `sadf` (see http://www.thegeekstuff.com/2011/03/sar-examples/)
# that can generate csv for sar out of the box

# Parses sar text output into a custom sar csv
# @example SarParser.new('sar.txt').write_to_csv(sar_csv)
# INPUT: sar.txt
# Linux 3.13.0-44-generic (ip-10-0-3-125)   02/19/2015   _x86_64_  (1 CPU)
#
# 03:16:26 PM     CPU     %user     %nice   %system   %iowait    %steal     %idle
# 03:16:56 PM     all      0.00      0.00      0.03      0.00      0.00     99.97
# 03:17:38 PM     all      0.00      0.00      0.05      0.00      0.05     99.91
# OUTPUT: sar.csv (columns: timestamp,user,steal)
# 2015-02-19 15:16:56 UTC,0.00,0.00
# 2015-02-19 15:17:38 UTC,0.00,0.05
class SarParser
  TIME_INDEX = 0
  USER_INDEX = 2
  SYSTEM_INDEX = 4
  IO_WAIT_INDEX = 5
  STEAL_INDEX = 6
  IDLE_INDEX = 7

  def initialize(sar_txt = 'sar.txt', skip_header = true)
    @sar_txt = sar_txt
    @skip_header = skip_header
    @date = nil
  end

  def write_to_csv(sar_csv = 'sar.csv', parser = self)
    CSV.open(sar_csv, 'wb') do |csv|
      File.open(@sar_txt, 'r').each_line do |line|
        @date ||= parse_date(line)
        csv << ( parse(line, parser) || next )
      end
    end
  end

  def parse_date(line)
    date_values = /(\d{2})\/(\d{2})\/(\d{4})/.match(line)
    Date.new(date_values[3].to_i, date_values[1].to_i, date_values[2].to_i)
  rescue
    nil
  end

  def parse(line, parser)
    cols = columns(line)
    return nil if skip_header_line?(cols)
    return nil if datetime(cols).nil?
    parser.emit(datetime(cols), cols)
  end

  def columns(line)
    line.split(/\s\s+/)
  end

  def skip_header_line?(cols)
    @skip_header && cols[USER_INDEX] == '%user'
  end

  def datetime(cols)
    time = Time.parse(cols[TIME_INDEX]) rescue(return nil)
    Time.utc(@date.year, @date.month, @date.day, time.hour, time.min, time.sec)
  end

  def emit(datetime, columns)
    [ datetime.to_s, columns[USER_INDEX], columns[STEAL_INDEX] ]
  end
end

class UserSarParser < SarParser
  def emit(datetime, columns)
    [ datetime.to_i, columns[USER_INDEX] ]
  end
end

class StealSarParser < SarParser
  def emit(datetime, columns)
    [ datetime.to_i, columns[STEAL_INDEX] ]
  end
end

class IdleSarParser < SarParser
  def emit(datetime, columns)
    [ datetime.to_i, columns[IDLE_INDEX] ]
  end
end
