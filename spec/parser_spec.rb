require 'schedule-checker/parser'

describe ScheduleChecker::Parser do

  it "#from_string error, two timezones" do
    filecontent = <<END
timezone: local
timezone: local
session: Mon/08:12:34-Tue/12:12:12
END
    expect { ScheduleChecker::Parser.new(filecontent) }.to raise_error
  end


  it "#from_string error, illegal timezone setting" do
    filecontent = <<END
timezone: error
session: Tue/08:12:34
END
    expect { ScheduleChecker::Parser.new(filecontent) }.to raise_error
  end


  it "#from_string error, unknown setting" do
    filecontent = <<END
bat: man
END
    expect { ScheduleChecker::Parser.new(filecontent) }.to raise_error
  end


  it "#from_string error, malformed session" do
    filecontent = <<END
session: Mon/08:12:34
END
    expect { ScheduleChecker::Parser.new(filecontent) }.to raise_error
  end


  it "#from_string nonstop can't coexist with a timed session" do
    filecontent = <<END
SESSION: Tue/12:12:34-Tue/15:01:01
SESSION: non-stop
END
    expect {sched = ScheduleChecker::Parser.new(filecontent)}.to raise_error
  end

end
