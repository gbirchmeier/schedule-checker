require 'session_schedule'
require 'timepoint'

describe SessionWindows::SessionSchedule do

  it "#in_a_session?" do
    sched = SessionWindows::SessionSchedule.new
    # set up 2 sessions: Tue and Thur from 8am-5pm UTC
    sched.add_session(SessionWindows::Timepoint.new(2,8,00,00),SessionWindows::Timepoint.new(2,17,0,0))
    sched.add_session(SessionWindows::Timepoint.new(4,8,00,00),SessionWindows::Timepoint.new(4,17,0,0))

    # tests from M-F
    sched.in_a_session?(Time.utc(2014,5, 5,12,00,00)).should be_false
    sched.in_a_session?(Time.utc(2014,5, 6,12,00,00)).should be_true
    sched.in_a_session?(Time.utc(2014,5, 7,12,00,00)).should be_false
    sched.in_a_session?(Time.utc(2014,5, 8,12,00,00)).should be_true
    sched.in_a_session?(Time.utc(2014,5, 9,12,00,00)).should be_false
  end

end
