require 'schedule-checker/session'
require 'schedule-checker/parser'

module ScheduleChecker
  class Schedule
    attr_reader :sessions
  
    def initialize()
      @sessions = [] # Session objects
    end

    def self.from_string(s)
      parser = ScheduleChecker::Parser.new(s)
      parser.to_schedule
    end
  
    def add_session(start_timepoint,end_timepoint)
      if self.in_a_session?(start_timepoint) || self.in_a_session?(end_timepoint)
        raise "new session overlaps with existing session"
      end
      @sessions << ScheduleChecker::Session.new(start_timepoint,end_timepoint)
    end
  
    def in_a_session?(t) # t is a timestamp
      @sessions.each{|s| return true if s.in_session?(t) }
      false
    end
  
  end
end
