require 'session'
require 'timepoint'

describe ScheduleChecker::Session do

  it "#in_session?" do
    sess = ScheduleChecker::Session.new(
      ScheduleChecker::Timepoint.new(2,18,00,00), #tue 6pm
      ScheduleChecker::Timepoint.new(3,02,00,00)) #wed 2am

    sess.in_session?(Time.utc(2014,5,6,17,59,59)).should be_false
    sess.in_session?(Time.utc(2014,5,6,18,00,00)).should be_true
    sess.in_session?(Time.utc(2014,5,7,01,59,59)).should be_true
    sess.in_session?(Time.utc(2014,5,7,02,00,00)).should be_false
  end

  it "#in_session? with non-UTC timestamps" do
    sess = ScheduleChecker::Session.new(
      ScheduleChecker::Timepoint.new(2,18,00,00), #tue 6pm
      ScheduleChecker::Timepoint.new(3,02,00,00)) #wed 2am

    sess.in_session?(Time.new(2014,5,6,19,59,59,"+02:00")).should be_false
    sess.in_session?(Time.new(2014,5,6,20,00,00,"+02:00")).should be_true
    sess.in_session?(Time.new(2014,5,7,03,59,59,"+02:00")).should be_true
    sess.in_session?(Time.new(2014,5,7,04,00,00,"+02:00")).should be_false
  end

  it "#in_session? when session wraps around Sat-Sun" do
    sess = ScheduleChecker::Session.new(
      ScheduleChecker::Timepoint.new(6,18,00,00), #sat 6pm
      ScheduleChecker::Timepoint.new(0,02,00,00)) #sun 2am

    sess.in_session?(Time.utc(2014,5,3,17,59,59)).should be_false
    sess.in_session?(Time.utc(2014,5,3,18,00,00)).should be_true
    sess.in_session?(Time.utc(2014,5,4,01,59,59)).should be_true
    sess.in_session?(Time.utc(2014,5,4,02,00,00)).should be_false
  end

end
