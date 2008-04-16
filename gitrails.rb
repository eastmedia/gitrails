#!/usr/bin/env ruby -w
#
# Create a Rails application that is hosted in an
# Git repository with log files, tmp files, and
# database.yml all being ignored.
#
# Written by Jonathan George <jonathan@jdg.net> 08/16/08
# Based on 'svnrails' by Matt Mower <self@mattmower.com> 07/02/07
# ... which is based on the Bash script by Akhil Bansal
# http://webonrails.com/2007/01/10/bash-script-for-creating-new-rails-project-and-initial-svn-import-with-ignoringremoving-logother-files/
#

if ARGV.size != 1
  puts "usage: gitrails <project name>"
  exit
end

project = ARGV[0]

puts "Creating rails application: #{project}"
`rails #{project}`

puts "Removing log files"
`cd #{project}; rm -rf log/*`
`cd #{project}; touch .gitignore; echo "log/*.log" >> .gitignore`
`cd #{project}; touch log/.gitignore`

puts "Removing tmp files"
`cd #{project}; echo "tmp/**/*" >> .gitignore`

puts "Moving database.yml to database.example.yml"
`cd #{project}; mv config/database.yml config/database.example.yml`
`cd #{project}; echo "config/database.yml" >> .gitignore`

puts "Importing application into repository"
`cd #{project}; git init`
`cd #{project}; git add .`
`cd #{project}; git commit -m "initial import"`

exit