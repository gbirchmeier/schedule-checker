require 'schedule-checker'

describe ScheduleChecker do

  it "has a dummy test that always passes" do
    1.should eq(1)
  end

  it "#onehundred" do
    ScheduleChecker.onehundred.should eq(100)
  end

end
