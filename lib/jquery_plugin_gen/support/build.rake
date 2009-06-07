begin
  %w[rake/clean].each { |f| require f }
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  %w[rake/clean].each { |f| require f }
end

CLEAN.include %w( build )

require 'jquery_plugin_gen/compiletask'

desc "Compile tasks"
Rake::CompileTask.new(PLUGIN)
