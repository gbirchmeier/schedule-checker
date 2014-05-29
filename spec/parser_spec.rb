require 'schedule-checker/parser'

describe ScheduleChecker::Parser do

  it "interprets utc correctly" do
    filecontent = <<END
# some comment
timEzone: utc
sesSions:
- Tue/08:12:34-Tue/15:01:01
- Thursday/13:00:00   -    Friday/13:00:00
# basically, day must have 3 letters or more
END
    sched = ScheduleChecker::Parser.new(filecontent).schedule
    sched.sessions.count.should eq 2
    sched.sessions[0].to_s.should eq "Session:Tue/08:12:34-Tue/15:01:01"
    sched.sessions[1].to_s.should eq "Session:Thu/13:00:00-Fri/13:00:00"
  end


  it "interprets local correctly" do
    filecontent = <<END
timezone: local
sessions:
- Tue/12:12:34-Tue/15:01:01
END
    sched = ScheduleChecker::Parser.new(filecontent).schedule
    sched.sessions.count.should eq 1
    # assumes test machine is Central zone (dst or not)
    sched.sessions[0].to_s.should match(/^Session:Tue\/1[78]:12:34-Tue\/2[01]:01:01/)
  end


  it "interprets non-stop correctly" do
    filecontent = <<END
SESSIONs:
- nonstop
END
    sched = ScheduleChecker::Parser.new(filecontent).schedule
    sched.nonstop.should be_true
  end


  it "errors if 'sessions' is not a list" do
    filecontent = <<END
SESSIONs: wooooooooooooooo
END
    expect { ScheduleChecker::Parser.new(filecontent) }.to raise_error
  end


it "errors on illegal timezone setting" do
    filecontent = <<END
timezone: error
sessions:
- Tue/08:12:34
END
    expect { ScheduleChecker::Parser.new(filecontent) }.to raise_error
  end


  it "errors on unknown setting" do
    filecontent = <<END
sessions:
- Tue/12:12:34-Tue/15:01:01
bat: man
END
    expect { ScheduleChecker::Parser.new(filecontent) }.to raise_error
  end


  it "errors on malformed session" do
    filecontent = <<END
sessions:
- Mon/08:12:34
END
    expect { ScheduleChecker::Parser.new(filecontent) }.to raise_error
  end


  it "errors when specifying nonstop and timed session" do
    filecontent = <<END
sessions:
- Tue/12:12:34-Tue/15:01:01
- non-stop
END
    expect { ScheduleChecker::Parser.new(filecontent) }.to raise_error
  end


  it "errors if no sessions" do
    filecontent = <<END
# I got nothing
END
    expect { ScheduleChecker::Parser.new(filecontent) }.to raise_error
  end

end
