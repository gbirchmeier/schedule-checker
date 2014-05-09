require 'schedule-checker/schedule'

module ScheduleChecker

  def self.parse_schedule_file(filename)
    str = File.read(filename)
    ScheduleChecker::Schedule.from_string(str)
  end

  def self.nonstop_schedule
    ScheduleChecker::Schedule.nonstop
  end

end
