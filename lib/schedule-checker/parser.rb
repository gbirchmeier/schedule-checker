require 'schedule-checker/schedule'
require 'schedule-checker/session'
require 'schedule-checker/timepoint'

module ScheduleChecker

  class Parser

    def initialize(s)
      @is_utc = true
      @session_string_pairs = []
      @found_timezone = false
      @nonstop = false

      s.split("\n").each{|l|
        line = l.strip
        next if line.start_with? "#"

        type,value = line.split(":",2)
        raise "malformed line: \"#{l}\"" if value.nil? or value.strip.empty?

        value.strip!
        case type.downcase
          when "timezone"
            parse_timezone(value)
          when "session"
            parse_session(value)
          else
            raise "unrecognized setting: #{type}"
        end
      }

      raise "invalid config: can't be nonstop and still have timed sessions" if @nonstop and @session_string_pairs.count>0
    end

    def to_schedule
      return ScheduleChecker::Schedule.nonstop if @nonstop

      sched = ScheduleChecker::Schedule.new
      @session_string_pairs.each{|pair|
        starttp = ScheduleChecker::Timepoint.from_string(pair[0],@is_utc)
        endtp = ScheduleChecker::Timepoint.from_string(pair[1],@is_utc)
        sched.add_session(starttp,endtp)
      }
      sched
    end

private
    def parse_timezone(s)
      raise "timezone can only appear once" if @found_timezone
      @found_timezone = true
      s.downcase!
      case s.downcase
        when "utc"
          @is_utc=true
        when "local"
          @is_utc=false
        else
          raise "unsupported timezone value: #{s}"
      end
    end

    def parse_session(s)
      if s.match(/non-?stop/)
        @nonstop = true
        return
      end
      raise "malformed session value: #{s}" unless s.include?("-")
      starttime,endtime = s.split("-",2)
      raise "malformed session value: #{s}" if starttime.nil? or endtime.nil?
      starttime.strip!
      endtime.strip!
      @session_string_pairs << [starttime,endtime]
    end

  end
end
