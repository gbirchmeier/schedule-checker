require 'schedule-checker/schedule'
require 'schedule-checker/timepoint'

describe ScheduleChecker::Schedule do

  it "rejects adding sessions that overlap with prior sessions" do
    sched = ScheduleChecker::Schedule.new
    s1 = ScheduleChecker::Session.new(
      ScheduleChecker::Timepoint.new(2,8,00,00),ScheduleChecker::Timepoint.new(2,17,0,0))
    s2 = ScheduleChecker::Session.new(
      ScheduleChecker::Timepoint.new(2,16,45,00),ScheduleChecker::Timepoint.new(2,21,0,0))

    sched.add_session(s1)
    expect { sched.add_session(s2) }.to raise_error
  end

  it "#in_a_session?" do
    sched = ScheduleChecker::Schedule.new
    # set up 2 sessions: Tue and Thur from 8am-5pm UTC
    s1 = ScheduleChecker::Session.new(
      ScheduleChecker::Timepoint.new(2,8,00,00),ScheduleChecker::Timepoint.new(2,17,0,0))
    s2 = ScheduleChecker::Session.new(
      ScheduleChecker::Timepoint.new(4,8,00,00),ScheduleChecker::Timepoint.new(4,17,0,0))
    sched.add_session(s1)
    sched.add_session(s2)

    # tests from M-F
    sched.in_a_session?(Time.utc(2014,5, 5,12,00,00)).should be_false
    sched.in_a_session?(Time.utc(2014,5, 6,12,00,00)).should be_true
    sched.in_a_session?(Time.utc(2014,5, 7,12,00,00)).should be_false
    sched.in_a_session?(Time.utc(2014,5, 8,12,00,00)).should be_true
    sched.in_a_session?(Time.utc(2014,5, 9,12,00,00)).should be_false
  end


  it "#in_a_schedule==true and #sessions.count==0 always for nonstop schedules" do
    sched = ScheduleChecker::Schedule.nonstop
    sched.in_a_session?("nonstop ignores this arg").should be_true
    sched.sessions.count.should ==0
  end

  it "can't add a session to a nonstop" do
    sched = ScheduleChecker::Schedule.nonstop
    s1 = ScheduleChecker::Session.new(
      ScheduleChecker::Timepoint.new(2,8,00,00),ScheduleChecker::Timepoint.new(2,17,0,0))
    expect { sched.add_session(s1) }.to raise_error
  end

end
