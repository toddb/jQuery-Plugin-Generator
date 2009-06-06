begin
  %w[rake fileutils simple-rss open-uri].each { |f| require f }
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  %w[rake tmpdir fileutils simple-rss open-uri].each { |f| require f }
end

lib_dir = 'lib'

namespace :jquery do
  
  desc "Add latest jquery core, ui and themes to #{lib_dir}"
  task :all => ['core:add', 'ui:add', 'themes:add']

  namespace :core do
   
    desc "List versions of released packages"
     task :packages do
       versions(jquery_atom){ |e| e.title }
     end
   
    desc "List jQuery packages available"
    task :versions do
      versions(jquery_atom){ |e| e.title.gsub(/jquery-(\d\.\d\.\d|\d\.\d).*/, '\1') }
    end
  
    desc "Add latest jQuery to library"
    task :add do
      uri = first(jquery_atom){ |e| e.content.gsub(/.*a href=&quot;(.*)&quot;.*/m, '\1') if e.title.include?('.min.js') }
      get_and_install(uri, lib_dir, 'jquery.min.js')  
    end
    
    desc "Add specific version of jQuery library: see with VERSION=X.X.X on command line"
    task :add_version do
      version = ENV['VERSION']
      return puts('No version specified - add VERSION=X.X.X to rake command') if version.nil?
      uri = first(jquery_atom){ |e| e.content.gsub(/.*a href=&quot;(.*)&quot;.*/m, '\1') if e.title.include?(version) }
      return puts("Specified version #{version} not found in repository - use rake jquery:core:versions to determine available versions") if uri.nil?
      get_and_install(uri, lib_dir, "jquery-#{version}.min.js") 
    end
  end

  namespace :ui do
  
    desc "List versions of released packages"
    task :packages do   
      versions(jqueryui_atom){ |e| e.title }
    end
  
    desc "List jQuery UI packages available"
    task :versions do
      versions(jqueryui_atom){ |e| e.title.gsub(/.*-(\d.\drc\d.\d|\d.\drc\d|\d\.\d\.\d|\d\.\d).*/, '\1') }
    end  
  
    desc "Add latest jQueryUI (without theme) to library"
    task :add do
      uri =  first(jqueryui_atom){ |e| e.content.gsub(/.*a href=&quot;(.*)&quot;.*/m, '\1') unless e.title.include?('themes') }  
      file = uri.gsub(/.*files\/(.*)(\d.\drc\d.\d|\d.\drc\d|\d\.\d\.\d|\d\.\d)(.*)/, '\1\2\3') 
      get_and_install(uri, lib_dir, file)
      unzip_and_install(lib_dir, file)
    end
  end
  
  namespace :themes do
   
    desc "Add all themes to libary"
    task :add do
      uri =  first(jqueryui_atom){ |e| e.content.gsub(/.*a href=&quot;(.*)&quot;.*/m, '\1') if e.title.include?('themes') }  
      file = uri.gsub(/.*files\/(.*)(\d.\drc\d.\d|\d.\drc\d|\d\.\d\.\d|\d\.\d)(.*)/, '\1\2\3') 
      get_and_install(uri, lib_dir, file)
      unzip_and_install(lib_dir, file)      
    end
  end       
end

  
  def jqueryui_atom
    puts "Checking jQueryUI respository on Google Code"
    SimpleRSS.parse open('http://code.google.com/feeds/p/jquery-ui/downloads/basic')        
  end

  def jquery_atom
    puts "Checking jQuery respository on Google Code"
    SimpleRSS.parse open('http://code.google.com/feeds/p/jqueryjs/downloads/basic')    
  end

  def versions(atom)
    versions = []
    atom.entries.each do |entry| 
      versions << yield(entry)
    end
    puts versions.uniq 
    versions     
end

def first(atom)
  atom.entries.each do |entry| 
    link = yield(entry)
    return link unless link.nil?
  end 
  nil  
end

def get_and_install(uri, path, file)
  puts "Downloading file #{uri}"
  download = URI.parse(uri)
  
  unless File.directory?(path)
    puts "Making new directory #{path}"
    FileUtils.mkdir_p(path)
  end
  
  new_file = File.join(path, file)
  puts "Saving new library file: #{new_file}"
  
  File.open(new_file, 'w') do |file|
    download.open { |jq| jq.each_line {|line| file.puts line} }    
  end
  new_file
end

def unzip_and_install(path, file)
  
  path = File.join(File.dirname(__FILE__), path)
  extracted_folder = File.join(Dir.tmpdir, file.gsub(/(.*)\.zip/, '\1'))

  if /mswin|mingw/ =~ RUBY_PLATFORM then
    zip = ENV['ZIP'] || '7z'
    puts "Extracting using #{zip} - this should be on your path or set the ZIP=path/to/zip/cmd on rake command"
    `#{zip} #{file} -o #{Dir.tmpdir}`
  else
    puts 'Extracting files'
    `unzip -o #{path}/#{file} -d #{Dir.tmpdir}`
  end
   
   puts 'Copying ui and themes'
   FileUtils.cp Dir.glob("#{extracted_folder}/ui/jquery*.js") , path
   FileUtils.cp_r "#{extracted_folder}/themes", path
   
   puts 'Cleaning extracted files'
   FileUtils.rm "#{path}/#{file}"
   FileUtils.rm_rf extracted_folder
end
