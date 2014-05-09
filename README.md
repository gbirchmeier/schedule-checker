schedule-checker
===============

A simple file format and module for specifying a weekly schedule of sessions and checking if a given time is within a session or not.


Session definition file:
---------

An example:

    # Timezone specifies if the sessions are specified in UTC or local.
    # => valid values: "utc" or "local"
    # => If not present, then "utc".
    timezone: utc
    # Define as many weekly sessions as you want.  Times are 24-hour time.
    # Overlapping sessions are invalid and will raise an error.
    # Sessions can span multiple days.
    session: Mon/08:00:00-Mon/17:00:00
    session: Tue/08:00:00-Tue/17:00:00
    session: Wed/08:00:00-Wed/17:00:00
    session: Thu/08:00:00-Thu/17:00:00
    session: Fri/08:00:00-Fri/14:00:00
    # You can also specify full-length day names if you like (e.g. "Friday/08:00:00")


How to load that file:
---

    require 'schedule-checker'
    schedule = ScheduleChecker.parse_schedule_file(filename)

    schedule.in_a_session?(Time.now)
