module ScheduleChecker
  class Session
    attr_reader :startpoint,:endpoint
  
    def initialize(startpoint,endpoint)
      @startpoint = startpoint
      @endpoint = endpoint
    end
  
    def in_session?(t) #t is a timestamp or Timepoint

      if startpoint.gt(endpoint)
        return startpoint.lte(t) || endpoint.gt(t)
      end
      startpoint.lte(t) && endpoint.gt(t)
    end
  
    def to_s
      "Session:#{startpoint.to_s}-#{endpoint.to_s}"
    end
  
  end
end
