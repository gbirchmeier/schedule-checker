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


  it "#in_a_schedule is always true for nonstop schedules" do
    sched = ScheduleChecker::Schedule.nonstop
    sched.in_a_session?("pants").should be_true
  end

  it "can't add a session to a nonstop" do
    sched = ScheduleChecker::Schedule.nonstop
    expect {
      sched.add_session(ScheduleChecker::Timepoint.new(2,16,45,00),ScheduleChecker::Timepoint.new(2,21,0,0))
    }.to raise_error
  end


  it "#from_string with utc" do
    filecontent = <<END
# some comment
timezone: utc
session: Tue/08:12:34-Tue/15:01:01
session: Thursday/13:00:00-Friday/13:00:00
# basically, day must have 3 letters or more
END
    sched = ScheduleChecker::Schedule.from_string(filecontent)
    sched.sessions.count.should eq 2
    sched.sessions[0].to_s.should eq "Session:Tue/08:12:34-Tue/15:01:01"
    sched.sessions[1].to_s.should eq "Session:Thu/13:00:00-Fri/13:00:00"
  end


  it "#from_string with local" do
    filecontent = <<END
TIMEZONE: local
SESSION: Tue/12:12:34-Tue/15:01:01
END
    sched = ScheduleChecker::Schedule.from_string(filecontent)
    sched.sessions.count.should eq 1
    # assumes test machine is Central zone (dst or not)
    sched.sessions[0].to_s.should match(/^Session:Tue\/1[78]:12:34-Tue\/2[01]:01:01/)
  end


  it "#from_string non-stop" do
    filecontent = <<END
SESSION: nonstop
END
    sched = ScheduleChecker::Schedule.from_string(filecontent)
    sched.nonstop.should be_true
    sched.sessions.count.should eq 0
  end


  it "#from_string empty schedule has no sessions" do
    filecontent = <<END
# I got nothing
END
    sched = ScheduleChecker::Schedule.from_string(filecontent)
    sched.nonstop.should be_false
    sched.sessions.count.should eq 0
  end

end
