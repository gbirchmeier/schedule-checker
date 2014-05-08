module ScheduleChecker
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

    def self.from_string(s,is_utc=true)
      raise "bad format '#{s}'" unless s.match(/^\w\w\w[\w]*\/\d\d:\d\d:\d\d$/)
      day_str,time_str = s.split("/")
      day = ScheduleChecker::Timepoint.day_str_to_i(day_str)
      h,m,s = time_str.split(":")
      ScheduleChecker::Timepoint.new(day,h.to_i,m.to_i,s.to_i,is_utc)
    end

    def normalized_ts_as_local
      @normalized_ts.get_local
    end
  
    def to_s
      @normalized_ts.strftime("#{wday_abbrev}/%H:%M:%S")
    end
  
    def lte(t)
      #only cares about wday and time
      x = t.is_a?(ScheduleChecker::Timepoint) ? t.normalized_ts : ScheduleChecker::Timepoint.normalize_timestamp(t)
      self.normalized_ts <= x
    end
  
    def gt(t)
      #only cares about wday and time
      x = t.is_a?(ScheduleChecker::Timepoint) ? t.normalized_ts : ScheduleChecker::Timepoint.normalize_timestamp(t)
      self.normalized_ts > x
    end

    def self.normalize_timestamp(ts)
      x = ts.getutc
      ScheduleChecker::Timepoint.new(x.wday,x.hour,x.min,x.sec).normalized_ts
    end
  
    DAYS = ["sun","mon","tue","wed","thu","fri","sat"]
    def self.pretty_day(n)
      raise "Illegal day int '#{n}'" unless (0..6).to_a.include?(n)
      DAYS[n].capitalize
    end
  
    def self.day_str_to_i(str)
      d = str.downcase.slice(0,3)
      rv = DAYS.find_index(d)
      raise "Illegal day string '#{str}'" unless rv
      rv
    end

  private
    def wday_abbrev
      ScheduleChecker::Timepoint.pretty_day(@normalized_ts.wday)
    end
  
  end
end
