begin
  %w[rake/clean].each { |f| require f }
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  %w[rake/clean].each { |f| require f }
end

CLEAN.include %w( build )
CLOBBER.include %w( dist )

require 'jquery_plugin_gen/compiletask'

desc "Compile tasks"
Rake::CompileTask.new('jquery.plugin') do ||
  # use defaults
end
