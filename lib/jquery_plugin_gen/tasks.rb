#!/usr/bin/env ruby

# import the rake tasks for use when having created a plugin

Dir['**/*.rake'].each { |t| load t }

