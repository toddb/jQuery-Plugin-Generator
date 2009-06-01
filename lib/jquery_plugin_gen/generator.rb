require 'fileutils'

module JqueryPluginGen
  class Generator
       
    X = 'FI' + 'X' 

    def self.base_dirs
      %w(src lib test dist src/images src/css test/data)
    end
       
    def self.execute(args)
      
      project = args[:project]
      
      case project
        when /_/ then
          file_name = project
          project = project.capitalize.gsub(/_([a-z])/) {$1.upcase}
          klass = project
        else
          file_name = project.gsub(/([A-Z])/, '_\1').downcase.sub(/^_/, '')
          klass = project.capitalize.gsub(/_([a-z])/) {$1.upcase}
      end

      Dir.mkdir project
      puts "creating folder: #{project}"
      
      Dir.chdir project do

        base_dirs.each do |path|
          puts "creating: #{path}"
          Dir.mkdir path
        end

       details = args
        files = {
          "Makefile" => QuickTemplate.erb('Makefile', details),
          "History.txt" => QuickTemplate.erb('History.txt', details),
          "README.txt" => QuickTemplate.erb('README.txt', details),
          "src/#{file_name}.js" => QuickTemplate.erb('src/plugin.js', details),
          "test/spec_#{file_name}.js" => QuickTemplate.erb('test/spec_plugin.js', details),
          "Rakefile" => QuickTemplate.erb('Rakefile', details),
          "src/css/screen.#{file_name}.css" => "",
          "test/specs.html" => QuickTemplate.erb('test/specs.html', details),
          "test/data/#{file_name}_01.json" => "",
          "test/data/#{file_name}_01.js" => "",
         }

        files["Manifest.txt"] = files.keys.sort.join("\n")

        files.each do |file, content|
          puts "creating: #{file}"
          File.open(file, "w") do |f|
            f.write content
          end
        end
      end
    end    
    
  end
end



