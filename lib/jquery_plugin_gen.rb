$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

$:.unshift(File.dirname(__FILE__) + '/jquery_plugin_gen')

require 'quick_template'
require 'generator'

module JqueryPluginGen
  VERSION = '0.1.0'
end