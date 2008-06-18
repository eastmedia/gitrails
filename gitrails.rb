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

def project
  ARGV[0]
end

def execute_in_current_dir(cmd)
  puts "** Executing #{cmd}"
  puts `#{cmd}`
end

def execute(cmd)
  cd = File.exists?(project) ? "cd #{project};" : ""
  puts "** Executing #{cmd}"
  puts `#{cd} #{cmd}`
end

puts "Creating rails application: #{project}"
execute "rails #{project}"

puts "Removing log files"
execute "rm -rf log/*"
execute "touch .gitignore; echo 'log/*.log' >> .gitignore"
execute "touch log/.gitignore"

puts "Removing tmp files"
execute "echo 'tmp/**/*' >> .gitignore"

puts "Moving database.yml to database.example.yml"
execute "mv config/database.yml config/database.example.yml"
execute "echo 'config/database.yml' >> .gitignore"

puts "Importing application into repository"
execute "git init"
execute "git add ."
execute "git commit -m 'initial import'"


########################
# Plugins 
#######################

puts "* Checkout out plugins (rspec, rspec_on_rails - it might take a while)"
execute "git submodule add git://github.com/dchelimsky/rspec.git          vendor/plugins/rspec"
execute "git submodule add git://github.com/dchelimsky/rspec-rails.git    vendor/plugins/rspec_on_rails"
execute "git add ."
execute "git commit -m '* Adding rspec, rspec on rails a submodule'"

puts "* Moving rspec and rspec on rails to 1.1.4 release"
execute_in_current_dir "cd #{project}/vendor/plugins/rspec;          git checkout 1.1.4"
execute_in_current_dir "cd #{project}/vendor/plugins/rspec_on_rails; git checkout 1.1.4"
execute "git add vendor/plugins/rspec"
execute "git add vendor/plugins/rspec_on_rails"
execute "git commit -m '* Moving rspec and rspec on rails to version 1.1.4'"

########################
# Rails
#######################
puts "* Checkout out rails in vendor/rails (this might take a while)"
execute "git submodule add git://github.com/rails/rails.git vendor/rails"
execute "git add ."
execute "git commit -m '* Adding vendor/rails a submodule'"

puts "* Moving rails to version 2.1 tag"
execute_in_current_dir "cd #{project}/vendor/rails; git checkout v2.1.0"
execute "git add ."
execute "git commit -m '* Moving rails to version 2.1'"




# We need the database setup to run these:
#
# puts "* Generating rspec configs"
# execute "./script/generate rspec"
# execute "git add script/spec spec"
# execute "git commit -m '* Generating configs for rspec'"


