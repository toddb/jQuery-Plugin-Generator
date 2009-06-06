#!/usr/bin/env ruby

# Define a compile task libarary to aid in the definition of
# redistributable package files of javascript/jquery plugins.

require 'rake'
require 'rake/tasklib'

module Rake

  # Create a packaging task that will package the project into
  # distributable files (e.g zip archive or tar files).
  #
  # The PackageTask will create the following targets:
  #
  # [<b>:compile</b>]
  #   Create all the requested package files.
  #
  # [<b>:clobber_compile</b>]
  #   Delete all the package files.  This target is automatically
  #   added to the main clobber target.
  #
  # [<b>:recompile</b>]
  #   Rebuild the package files from scratch, even if they are not out
  #   of date.
  #
  # [<b>"<em>package_dir</em>/<em>name</em>-<em>version</em>.tgz"</b>]
  #   Create a gzipped tar package (if <em>need_tar</em> is true).  
  #
  # [<b>"<em>package_dir</em>/<em>name</em>-<em>version</em>.tar.gz"</b>]
  #   Create a gzipped tar package (if <em>need_tar_gz</em> is true).  
  #
  # [<b>"<em>package_dir</em>/<em>name</em>-<em>version</em>.tar.bz2"</b>]
  #   Create a bzip2'd tar package (if <em>need_tar_bz2</em> is true).  
  #
  # [<b>"<em>package_dir</em>/<em>name</em>-<em>version</em>.zip"</b>]
  #   Create a zip package archive (if <em>need_zip</em> is true).
  #
  # Example:
  #
  #   JqueryPluginGen::CompileTask.new('query.plugin') do |p|
  #     p.js_files.include("src/**/*.js")
  #     p.css_files.include("src/css/**/*.css")
  #     p.image_files.include("src/images/**/*.*")
  #     p.js_dir = "src"
  #     p.images_dir = "src/images"
  #     p.css_dir = "src/css"
  #     p.package_files.include("README.txt", "HISTORY.txt")
  #     p.package_dir = "build"
  #   end
  #
     
  class CompileTask < TaskLib

    # Name of the plugin files (don't add .js).
    attr_accessor :name

    # Directory used to store the package files (default is 'src/images').
    attr_accessor :image_dir

    # Directory used to store the package files (default is 'src/css').
    attr_accessor :css_dir

    # Directory used to store the package files (default is 'build').
    attr_accessor :package_dir

    # True if a gzipped tar file (tgz) should be produced (default is true).
    attr_accessor :need_sed

    # True if a gzipped tar file (tar.gz) should be produced (default is true).
    attr_accessor :need_packer

    # List of files to be included in the package.
    attr_accessor :package_files

    # List of files to be included in the package.
    attr_accessor :js_files

    # List of files to be included in the package.
    attr_accessor :css_files

    # List of files to be included in the package.
    attr_accessor :image_files

    # Create a Compile Task
    def initialize(name)
      init
      yield self if block_given?
      define(name) unless name.nil?
    end

    # Initialization that bypasses the "yield self" and "define" step.
    def init
      @package_files = Rake::FileList["README.txt", "HISTORY.txt"]
      @package_dir = 'build'
      @need_sed = true
      @need_packer = true
      @sed_command = "sed -e '1 s/^\xEF\xBB\xBF//'"
      @packer_command = 'perl -I$ lib/packer lib/packer/jsPacker.pl -i #{name}.js -o #{name}.min.js -e62'
      @images_dir = 'src/images'
      @css_dir = 'src/css'
      @js_dir = 'src'
      @js_files = Rake::FileList.new
      @js_files.include("#{@js_dir}/**/*.js")
      @image_files = Rake::FileList.new
      @image_files.include("#{@image_dir}/**/*.*")
      @css_files = Rake::FileList.new
      @css_files.include("#{@css_dir}/**/*.css")     
    end

    # Create the tasks defined by this task library.
    def define(name)

      desc "Build all the packages"
      task :compile
      
      desc "Force a rebuild of the package files"
      task :recompile => [:clobber_compile, :compile]
      
      desc "Remove compile products" 
      task :clobber_compile do
        rm_r package_dir rescue nil
      end
      
      desc "Merge js files into one"
      task :merge do
        `#{sed_command} #{js_files} > #{name}.js`
      end
      
      desc "Compress js files to min"
      task :compress => :merge do
        # FIX
        `#{packer_command} `
      end

      task :clobber => [:clobber_compile]

      [package_dir, image_dir, css_dir].each { |dir| mkdir_p dir rescue nil }

      # directory package_dir
      # 
      # file package_dir_path => @package_files do
      #   [package_dir, image_dir, css_dir].each { |dir| mkdir_p dir rescue nil }
      #   @package_files.each do |fn|
      #     f = File.join(package_dir_path, fn)
      #     fdir = File.dirname(f)
      #     mkdir_p(fdir) if !File.exist?(fdir)
      #     if File.directory?(fn)
      #       mkdir_p(f)
      #     else
      #       rm_f f
      #       safe_ln(fn, f)
      #     end
      #   end
      # end
      self
    end
      
    def package_dir_path
      "#{package_dir}/#{package_name}"
    end

  end

end
