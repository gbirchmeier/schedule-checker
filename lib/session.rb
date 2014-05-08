class SessionWindows::Session
  attr_reader :startpoint,:endpoint

  def initialize(startpoint,endpoint)
    @startpoint = startpoint
    @endpoint = endpoint
  end

  def in_session?(t) #t is a timestamp or Timepoint
    return SessionWindows::Session.in_session_comparison(@startpoint,@endpoint,t)
  end

  def to_s
    "Session:#{startpoint.to_s}-#{endpoint.to_s}"
  end

  def self.in_session_comparison(startpoint,endpoint,t)
    a = SessionWindows::Session.normalize_timepoint(startpoint)
    b = SessionWindows::Session.normalize_timepoint(endpoint)
    x = t
    if t.is_a?(SessionWindows::Timepoint)
      x = SessionWindows::Session.normalize_timepoint(t)
    else unless t.utc?
      x = t.getgm
    end

    #TODO need special case for wrap-around sessions

    a <= x && x < t
  end

  def self.normalize_timepoint(tp)
    mdate = tp.day + 1
    Time.gm(2012,1,mdate,tp.hour,tp.minute,tp.second)
  end
end
