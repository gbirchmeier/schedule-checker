require 'schedule-checker/schedule'
require 'schedule-checker/session'
require 'schedule-checker/timepoint'
require 'yaml'

module ScheduleChecker

  class Parser
    attr_reader :config, :schedule

    ALLOWED_KEYS = ["sessions","timezone"]

    def initialize(s)
      session_string_pairs = []
      nonstop = false

      @config = Parser.downcase_keys(YAML.load(s))

      check_keys

      is_utc = is_utc?

      raise "no sessions specified" unless @config["sessions"] and @config["sessions"].length > 0

      sessions = []
      raise "sessions should be a list" unless @config["sessions"].is_a? Array

      @config["sessions"].each do |session_string|
        s = session_string.downcase.strip

        #TODO - come back later and make this nonstop-session processing better
        #  Should probably have non-stop be a property of Session, not Schedule, and 
        #  rely on Schedule to check for timed/nonstop session conflicts.

        if ["nonstop","non-stop"].include?(s)
          raise "config can't simultaneously be non-stop and have scheduled sessions" if sessions.length>0
          nonstop = true
        else
          raise "config can't simultaneously be non-stop and have scheduled sessions" if nonstop
          sessions << Parser.parse_session(s,is_utc)
        end
      end
      
      if(nonstop)
        @schedule = ScheduleChecker::Schedule.nonstop
      else
        @schedule = ScheduleChecker::Schedule.new
        sessions.each{|s| @schedule.add_session(s)}
      end
    end

  private
    def self.downcase_keys(h)
      rv = {}
      h.each{|k,v| rv[k.downcase] = v }
      rv
    end

    def check_keys
      @config.keys.each{|k| raise "unsupported setting '#{k}'" unless ALLOWED_KEYS.include?(k) }
    end

    def is_utc?
      return true unless @config.has_key?("timezone")
      case @config["timezone"].downcase
        when "utc"
          true
        when "local"
          return false
        else
          raise "unsupported timezone value: #{s}"
      end
    end

    def self.parse_session(s,is_utc)
      raise "malformed session value: #{s}" unless s.include?("-")
      starttime,endtime = s.split("-",2)
      raise "malformed session value: #{s}" if starttime.nil? or endtime.nil?
      starttime.strip!
      endtime.strip!
      ScheduleChecker::Session.new(
        ScheduleChecker::Timepoint.from_string(starttime,is_utc),
        ScheduleChecker::Timepoint.from_string(endtime,is_utc))
    end
  end

end
