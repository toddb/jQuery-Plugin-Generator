begin
  require 'spec'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  gem 'rspec'
  require 'spec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'jquery_plugin_gen'

def base_dir
  File.dirname(__FILE__) + '/../~jq-plugin/'
end 

def generated_file(file)
  File.read(File.dirname(__FILE__) + '/data/templates/' + file)
end

def spec_file
  
end

def details
  {:version => '0.1.0', :project => 'email'}
end
