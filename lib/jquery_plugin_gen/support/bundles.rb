namespace :bundles do

  desc 'Install TextMate bundles for jQuery and Jsspec(include in general javascript)'
  task :tm do
    require 'tmpdir'
    require 'fileutils'
    bundle = ["JavaScript jQuery.tmbundle", "JavaScript.tmbundle"].each { |bundle|
      bundle_dir = File.join(File.dirname(__FILE__), %w[.. .. bundles], bundle)
      FileUtils.cp_r bundle_dir Dir.tmpdir
      `open "#{File.join(Dir.tmpdir, bundle)}"`
    }
  end
  
  desc 'Install TextMate bundles from SVN for jQuery and Jsspec(include in general javascript). This requires svn to be installed.'
  task :tm_svn do
    require 'tmpdir'
    require 'fileutils'
    bundle = ["JavaScript jQuery.tmbundle", "JavaScript.tmbundle"].each { |bundle|
      bundle_dir = Dir.tmpdir
      `svn co http://svn.textmate.org/trunk/Bundles/#{bundle} #{bundle_dir}`
      `open "#{File.join(bundle_dir, bundle)}"`
    }
  end
end

