require 'session-windows'

describe SessionWindows do

  it "has a dummy test that always passes" do
    1.should eq(1)
  end

  it "#onehundred" do
    SessionWindows.onehundred.should eq(100)
  end

end
