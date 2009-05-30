require 'optparse'

module Jqp
  class CLI
    def self.execute(stdout, arguments=[])

      # NOTE: the option -p/--path= is given as an example, and should be replaced in your application.

      options = {
        :project     => '~jq-plugin',
        :version     => '0.0.1'
      }
      mandatory_options = %w(  )

      parser = OptionParser.new do |opts|
        opts.banner = <<-BANNER.gsub(/^          /,'')
          jQuery plugin generator to help you kick start your plugin development with the following structure:
          
           plugin
             /src
               /css
               /images
               query.plugin.js
             /test
               spec_plugin.js
             /dist
             Makefile
             Rakefile
             History.txt
             README.txt

          Usage: #{File.basename($0)} [options]

          Options are:
        BANNER
        opts.separator ""
        opts.on("-p", "--project=Name", String,
                "The project name should be simple eg 'widget'",
                "And it will be transformed to jquery.widget.js - there is currently no override feature on this naming convention",
                "Default: ~jq-plugin") { |arg| options[:project] = arg }
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
      
      stdout.puts "To update this executable, look in lib/jqp/cli.rb"
    end
  end
end