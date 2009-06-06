namespace :bundles do
  
  BUNDLES = ["JavaScript\ jQuery.tmbundle", "JavaScript.tmbundle"]

  desc 'Install TextMate bundles for jQuery and Jsspec(include in general javascript)'
  task :tm do
    require 'tmpdir'
    require 'fileutils'
    BUNDLES.each { |bundle|
      bundle_dir = File.join(File.dirname(__FILE__), "../../../bundles", bundle)
      FileUtils.cp_r(bundle_dir, Dir.tmpdir)
      `open "#{File.join(Dir.tmpdir, bundle)}"`
    }
  end
  
  desc 'Install TextMate bundles from SVN for jQuery and Jsspec(include in general javascript). This requires svn to be installed.'
  task :tm_svn do
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

