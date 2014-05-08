require 'schedule-checker/schedule'
require 'schedule-checker/timepoint'

describe ScheduleChecker::Schedule do

  it "rejects adding sessions that overlap with prior sessions" do
    sched = ScheduleChecker::Schedule.new
    sched.add_session(ScheduleChecker::Timepoint.new(2,8,00,00),ScheduleChecker::Timepoint.new(2,17,0,0))
    expect {
      sched.add_session(ScheduleChecker::Timepoint.new(2,16,45,00),ScheduleChecker::Timepoint.new(2,21,0,0))
    }.to raise_error
  end

  it "#in_a_session?" do
    sched = ScheduleChecker::Schedule.new
    # set up 2 sessions: Tue and Thur from 8am-5pm UTC
    sched.add_session(ScheduleChecker::Timepoint.new(2,8,00,00),ScheduleChecker::Timepoint.new(2,17,0,0))
    sched.add_session(ScheduleChecker::Timepoint.new(4,8,00,00),ScheduleChecker::Timepoint.new(4,17,0,0))

    # tests from M-F
    sched.in_a_session?(Time.utc(2014,5, 5,12,00,00)).should be_false
    sched.in_a_session?(Time.utc(2014,5, 6,12,00,00)).should be_true
    sched.in_a_session?(Time.utc(2014,5, 7,12,00,00)).should be_false
    sched.in_a_session?(Time.utc(2014,5, 8,12,00,00)).should be_true
    sched.in_a_session?(Time.utc(2014,5, 9,12,00,00)).should be_false
  end

end
