require "bundler/gem_tasks"

desc 'Start a Totem interactive console (with Activerecord)'
task :console do
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

  require 'irb'

  require 'totem'
  require 'totem_activerecord'

  ARGV.clear
  IRB.start
end
