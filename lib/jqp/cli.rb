require 'optparse'

module Jqp
  class CLI
    def self.execute(stdout, arguments=[])

      options = {
        :project     => 'jqplugin',
        :version     => '0.0.1'
      }
      mandatory_options = %w(project)

      parser = OptionParser.new do |opts|
        opts.banner = <<-BANNER.gsub(/^          /,'')
          jQuery plugin generator to help you kick start your plugin
          development with the following structure:
          
           plugin
             /src
               /css
               /images
               query.plugin.js
             /test
               spec_plugin.js
               acceptance_plugin.js
               specs.html
               acceptance.html
             /lib
              /jsspec
              jquery.min.js
              jquery-ui.js
              /themes
                /base
             example.html
             Rakefile
             History.txt
             README.txt
 
 
          Dependencies: svn, unzip, sed and perl
          
          Note: Windows users require svn, 7zip, sed and perl to 
                be on PATH to be available for use
          
          Usage: #{File.basename($0)} [options]

          Options are:
        BANNER
        opts.separator ""
        opts.on("-p", "--project=Name", String,
                "The project name should be simple eg 'widget'",
                "And it will be transformed to jquery.widget.js - there is currently no override feature on this naming convention",
                "Default: jqplugin") { |arg| options[:project] = arg }
        opts.on("-v", "--version=x.x.x", String,
                "Default: 0.0.1") { |arg| options[:version] = arg }
        opts.on("-h", "--help",
                "Show this help message.") { stdout.puts opts; exit }
        opts.parse!(arguments)

        if mandatory_options && mandatory_options.find { |option| options[option.to_sym].nil? }
          stdout.puts opts; exit
        end
      end

      JqueryPluginGen::Generator.execute(options)
      
      stdout.puts <<-MSG
      
**********************************************************

Now include the jQuery libraries with:

  cd jqplugin [or your plugin]
  rake first_time

First time will:
 - add jquery core, ui and base themes
 - compile js to a packed version (see build directory)
 - load three html files in your browser to demon
    1. Acceptance tests
    2. Spec tests
    3. Example page
    
Note: you don't have to add jquery core, ui and themes.
However, if you don't you will need to update the html 
pages (example.html, test/spec.html). To see other options
use rake -T

Dependencies: svn, unzip, sed and perl

Note: Windows users require svn, 7zip, sed and perl to 
      be on PATH to be available for use

**********************************************************

MSG
    end
  end
end