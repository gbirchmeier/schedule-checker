require 'schedule-checker/parser'
require 'schedule-checker/session'

module ScheduleChecker
  class Schedule
    attr_reader :sessions,:nonstop
  
    def initialize(nonstop=false)
      @sessions = [] # Session objects
      @nonstop = nonstop
    end

    def self.nonstop
      ScheduleChecker::Schedule.new(true)
    end

    def add_session(session)
      raise "can't add to a non-stop schedule" if @nonstop

      if self.in_a_session?(session.startpoint) || self.in_a_session?(session.endpoint)
        raise "new session overlaps with existing session"
      end
      @sessions << session
    end
  
    def in_a_session?(t) # t is a timestamp
      return true if @nonstop
      @sessions.each{|s| return true if s.in_session?(t) }
      false
    end
  
  end
end
