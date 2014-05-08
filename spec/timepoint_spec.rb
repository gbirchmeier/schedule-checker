require 'schedule-checker/timepoint'

describe ScheduleChecker::Timepoint do

  it "::pretty_day" do
    ScheduleChecker::Timepoint.pretty_day(0).should eq "Sun"
    ScheduleChecker::Timepoint.pretty_day(5).should eq "Fri"
    expect {ScheduleChecker::Timepoint.pretty_day(7)}.to raise_error
  end

  it "::day_str_to_i" do
    ScheduleChecker::Timepoint.day_str_to_i("tUe").should eq 2
    expect {ScheduleChecker::Timepoint.day_str_to_i("pants")}.to raise_error
  end

  it "ctor and #to_s" do
    ScheduleChecker::Timepoint.new(0,12,1,1).to_s.should eq "Sun/12:01:01"
    ScheduleChecker::Timepoint.new(0,12,1,1,true).to_s.should eq "Sun/12:01:01"

    # two possible answers depending on DST.  (Assumes running in Central time zone)
    ScheduleChecker::Timepoint.new(0,12,1,1,false).to_s.should match(/^Sun\/1[78]:01:01$/)
  end

  it "::from_string" do
    ScheduleChecker::Timepoint.from_string("mOn/12:12:12").to_s.should eq "Mon/12:12:12"
    ScheduleChecker::Timepoint.from_string("Tuesd/12:12:12").to_s.should eq "Tue/12:12:12"
  end

  it "#lte" do
    tp = ScheduleChecker::Timepoint.new(3,12,00,00)
    tp.lte(ScheduleChecker::Timepoint.new(3,11,59,59)).should be_false
    tp.lte(ScheduleChecker::Timepoint.new(3,12,00,00)).should be_true
    tp.lte(ScheduleChecker::Timepoint.new(3,12,00,01)).should be_true

    tp.lte(Time.utc(2014,5,7,11,59,59)).should be_false
    tp.lte(Time.utc(2014,5,7,12,00,00)).should be_true
    tp.lte(Time.utc(2014,5,7,12,00,01)).should be_true
  end

  it "#gt" do
    tp = ScheduleChecker::Timepoint.new(3,12,00,00)
    tp.gt(ScheduleChecker::Timepoint.new(3,11,59,59)).should be_true
    tp.gt(ScheduleChecker::Timepoint.new(3,12,00,00)).should be_false
    tp.gt(ScheduleChecker::Timepoint.new(3,12,00,01)).should be_false

    tp.gt(Time.utc(2014,5,7,11,59,59)).should be_true
    tp.gt(Time.utc(2014,5,7,12,00,00)).should be_false
    tp.gt(Time.utc(2014,5,7,12,00,01)).should be_false
  end

  it "#lte with non-UTC timestamps" do
    tp = ScheduleChecker::Timepoint.new(3,12,00,00)
    tp.lte(Time.new(2014,5,7,13,59,59,"+02:00")).should be_false
    tp.lte(Time.new(2014,5,7,14,00,00,"+02:00")).should be_true
    tp.lte(Time.new(2014,5,7,14,00,01,"+02:00")).should be_true
  end

end
