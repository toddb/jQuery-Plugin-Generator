require "erb"
 
module JqueryPluginGen
  class QuickTemplate
    attr_reader :args, :text, :file, :path
    
    details = {:version => 'xxx'}
    
    def initialize(file, path="")
      @path = path.empty? ? File.dirname(__FILE__) + '/../templates/' : path
      @file = @path + file + '.erb'
      @text = File.read(@file)
    end
    
    def exec(b)
      begin
        details = b
        # b = binding
        template = ERB.new(@text, 0, "%<>")
        result = template.result(binding)
        # Chomp the trailing newline
        #result.gsub(/\n$/,'')
        result
      rescue NameError
        puts "Error found for #{@file}"
        raise $!
      end
    end

    def self.erb(file, b, path="")
       QuickTemplate.new(file, path).exec(b)
    end
  end

end
