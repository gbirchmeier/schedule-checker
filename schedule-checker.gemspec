Gem::Specification.new do |s|
  s.name        = 'schedule-checker'
  s.version     = '0.0.2'
  s.date        = '2014-05-09'
  s.summary     = "A simple file format and module for specifying a weekly schedule of sessions and checking if a given time is within a session or not."
#  s.description = "TBA"
  s.authors     = ["Grant Birchmeier"]
  s.email       = 'grant@grantb.net'
  s.files       = [
                    "lib/schedule-checker.rb",
                    "lib/schedule-checker/parser.rb",
                    "lib/schedule-checker/schedule.rb",
                    "lib/schedule-checker/session.rb",
                    "lib/schedule-checker/timepoint.rb",
                    "lib/schedule-checker.rb",
                  ]
  s.homepage    = 'http://github.com/gbirchmeier/schedule-checker'
  s.license     = 'MIT'
end
