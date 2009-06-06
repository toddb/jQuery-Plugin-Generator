#!/usr/bin/env ruby

# import the rake tasks for use when having created a plugin

Dir.glob(File.join(File.dirname(__FILE__), '**/*.rake')).each { |t| import t rescue nil}
