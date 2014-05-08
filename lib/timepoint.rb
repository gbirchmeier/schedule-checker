module SessionWindows
  class Timepoint
    attr_reader :normalized_ts
  
    # day: 0-6 for Sunday-Saturday
    # hour: 0-24
    def initialize(day,hour,minute,second,is_utc=true)
      raise "invalid day (must be 0-6, 0 is Monday)" unless (0..6).to_a.include?(day)
      @normalized_ts = is_utc ?
        Time.utc(2012,1,day+1,hour,minute,second) :
        Time.local(2012,1,day+1,hour,minute,second).getutc
    end

    def normalized_ts_as_local
      @normalized_ts.get_local
    end
  
    def to_s
      @normalized_ts.strftime("#{wday_abbrev}/%H:%M:%S")
    end
  
    def lte(t)
      #only cares about wday and time
      x = t.is_a?(SessionWindows::Timepoint) ? t.normalized_ts : SessionWindows::Timepoint.normalize_timestamp(t)
      self.normalized_ts <= x
    end
  
    def gt(t)
      #only cares about wday and time
      x = t.is_a?(SessionWindows::Timepoint) ? t.normalized_ts : SessionWindows::Timepoint.normalize_timestamp(t)
      self.normalized_ts > x
    end

    def self.normalize_timestamp(ts)
      x = ts.getutc
      SessionWindows::Timepoint.new(x.wday,x.hour,x.min,x.sec).normalized_ts
    end
  
    def self.pretty_day(n)
      case n
        when 0 then "Sun"
        when 1 then "Mon"
        when 2 then "Tue"
        when 3 then "Wed"
        when 4 then "Thu"
        when 5 then "Fri"
        when 6 then "Sat"
        else raise "Illegal day value"
      end
    end
  
  private
    def wday_abbrev
      SessionWindows::Timepoint.pretty_day(@normalized_ts.wday)
    end
  
  end
end
