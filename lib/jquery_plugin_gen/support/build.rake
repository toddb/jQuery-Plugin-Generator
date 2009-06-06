begin
  %w[rake/clean].each { |f| require f }
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  %w[rake/clean].each { |f| require f }
end

CLEAN.include %w( build )
CLOBBER.include %w( dist )
