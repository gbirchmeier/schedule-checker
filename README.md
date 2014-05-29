schedule-checker
===============

A module for specifying a weekly schedule of sessions and checking if a given time is within a session or not.


Session definition file:
---------

The session definition file is YAML.

Here's an example schedule file that sets 8am-5pm sessions every day except for Friday, which ends early at 2pm.

    # Timezone specifies if the sessions are specified in UTC or local.
    # => valid values: "utc" or "local"
    # => If not present, then "utc".
    timezone: utc

    # Define as many weekly sessions as you want.  Times are 24-hour time.
    # Overlapping sessions are invalid and will raise an error.
    # Sessions can span multiple days.
    sessions:
    - Mon/08:00:00-Mon/17:00:00
    - Tue/08:00:00-Tue/17:00:00
    - Wed/08:00:00-Wed/17:00:00
    - Thu/08:00:00-Thu/17:00:00
    - Fri/08:00:00-Fri/14:00:00
    # (You can also specify full-length day names if you like (e.g. "Friday/08:00:00"))

To specify a non-stop session, this is all you need:

    sessions:
    - non-stop
    # "nonstop" without hyphen is also acceptable



How to load and use that file:
---

    require 'schedule-checker'
    schedule = ScheduleChecker.parse_schedule_file(filename)

    schedule.in_a_session?(Time.now)   #utc or local times both work
