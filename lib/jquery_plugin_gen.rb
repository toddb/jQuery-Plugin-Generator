$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'jquery_plugin_gen/quick_template'
require 'jquery_plugin_gen/generator'

module JqueryPluginGen
  VERSION = '0.2.1'
end