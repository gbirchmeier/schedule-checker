require 'schedule-checker/schedule'

module ScheduleChecker

  def self.parse_schedule_file(filename)
    str = File.read(filename)
    ScheduleChecker::Schedule.from_string(str)
  end

end
