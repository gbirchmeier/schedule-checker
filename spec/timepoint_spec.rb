require 'timepoint'

describe SessionWindows::Timepoint do

  it "#pretty_day class method" do
    SessionWindows::Timepoint.pretty_day(0).should eq "Sun"
    SessionWindows::Timepoint.pretty_day(5).should eq "Fri"
    expect {SessionWindows::Timepoint.pretty_day(7)}.to raise_error
  end

  it "ctor and #to_s" do
    SessionWindows::Timepoint.new(0,12,1,1).to_s.should eq "Sun/12:01:01"
    SessionWindows::Timepoint.new(0,12,1,1,true).to_s.should eq "Sun/12:01:01"

    # two possible answers depending on DST.  (Assumes running in Central time zone)
    expect(["Sun/17:01:01","Sun/18:01:01"]).to include SessionWindows::Timepoint.new(0,12,1,1,false).to_s
  end

  it "#lte" do
    tp = SessionWindows::Timepoint.new(3,12,00,00)
    tp.lte(SessionWindows::Timepoint.new(3,11,59,59)).should be_false
    tp.lte(SessionWindows::Timepoint.new(3,12,00,00)).should be_true
    tp.lte(SessionWindows::Timepoint.new(3,12,00,01)).should be_true

    tp.lte(Time.utc(2014,5,7,11,59,59)).should be_false
    tp.lte(Time.utc(2014,5,7,12,00,00)).should be_true
    tp.lte(Time.utc(2014,5,7,12,00,01)).should be_true
  end

  it "#gt" do
    tp = SessionWindows::Timepoint.new(3,12,00,00)
    tp.gt(SessionWindows::Timepoint.new(3,11,59,59)).should be_true
    tp.gt(SessionWindows::Timepoint.new(3,12,00,00)).should be_false
    tp.gt(SessionWindows::Timepoint.new(3,12,00,01)).should be_false

    tp.gt(Time.utc(2014,5,7,11,59,59)).should be_true
    tp.gt(Time.utc(2014,5,7,12,00,00)).should be_false
    tp.gt(Time.utc(2014,5,7,12,00,01)).should be_false
  end

  it "#lte with non-UTC timestamps" do
    tp = SessionWindows::Timepoint.new(3,12,00,00)
    tp.lte(Time.new(2014,5,7,13,59,59,"+02:00")).should be_false
    tp.lte(Time.new(2014,5,7,14,00,00,"+02:00")).should be_true
    tp.lte(Time.new(2014,5,7,14,00,01,"+02:00")).should be_true
  end

end
