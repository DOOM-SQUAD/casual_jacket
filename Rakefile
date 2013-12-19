# Helper Functions
# ----------------
def base_path
  File.dirname(File.expand_path(__FILE__))
end

def boot_file_name
  @name ||= Dir[File.join(base_path, 'lib', 'casual_jacket.rb')].first
end

# Dependencies
# ------------
require 'bundler/setup'
require boot_file_name

Bundler.require(:default)

# Tasks
# --------------
task :default => [:spec]

task :spec do
  sh "rspec spec/"
end

desc "Boot an application console in a pry REPL"
task :impc do
  sh "pry -r #{boot_file_name}"
end
