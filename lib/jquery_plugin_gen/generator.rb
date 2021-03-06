require 'fileutils'
require 'rake'

module JqueryPluginGen
  class Generator
       
    def self.base_dirs
      %w(src lib test src/images src/css test/data tasks)
    end
    
    def self.copy_jsspec
      FileUtils.cp_r(File.join(File.dirname(__FILE__), "../jsspec"), 'lib')
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
      
      return puts("project: #{project} already exists") if File.directory?(project)
 
      Dir.mkdir(project) 
      puts "creating folder: #{project}"
      
      Dir.chdir project do

        base_dirs.each do |path|
          puts "creating: #{path}"
          Dir.mkdir path
        end
        
        copy_jsspec

        details = args
        files = {
          "Rakefile" => QuickTemplate.erb('Rakefile', details),
          "History.txt" => QuickTemplate.erb('History.txt', details),
          "README.txt" => QuickTemplate.erb('README.txt', details),
          "example.html" => QuickTemplate.erb('example.html', details),
          "src/#{file_name}.js" => QuickTemplate.erb('src/plugin.js', details),
          "src/css/screen.#{file_name}.css" => "",
          "test/specs.html" => QuickTemplate.erb('test/specs.html', details),
          "test/spec_#{file_name}.js" => QuickTemplate.erb('test/spec_plugin.js', details),
          "test/data/#{file_name}_01.json" => "",
          "test/data/#{file_name}_01.js" => "",
          "test/acceptance.html" => QuickTemplate.erb('test/acceptance.html', details),
          "test/acceptance_#{file_name}.js" => QuickTemplate.erb('test/spec_plugin.js', details),
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



