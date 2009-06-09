namespace :bundles do
  
  BUNDLES = ["JavaScript\ jQuery.tmbundle", "JavaScript.tmbundle"]
 
  desc 'Install TextMate bundles from SVN for jQuery and Jsspec(include in general javascript). This requires svn to be installed.'
  task :tm do
    require 'tmpdir'
    require 'fileutils'
    BUNDLES.each { |bundle|
      bundle_filename = File.join(Dir.tmpdir, bundle)
      puts "Getting #{bundle} from svn http://svn.textmate.org/trunk/Bundles/#{bundle} and will open in Textmate"
      `svn export --force "http://svn.textmate.org/trunk/Bundles/#{bundle}" "#{bundle_filename}"`
      `open "#{bundle_filename}"`
    }
  end
end

