#!/usr/bin/env ruby

# Define a compile task libarary to aid in the definition of
# redistributable package files of javascript/jquery plugins.

require 'rake'
require 'rake/tasklib'
require 'fileutils'

module Rake

  # Create a compiling task that will build the project into
  # distributable files (e.g a single and a packed js file with compression).
  #
  # The CompileTask will create the following targets:
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
  # Example:
  #
  #   JqueryPluginGen::CompileTask.new('query.plugin') do |p|
  #     p.js_files.include("src/**/*.js")
  #     p.css_files.include("src/css/**/*.css")
  #     p.image_files.include("src/images/**/*.*")
  #     p.js_dir = "src"
  #     p.images_dir = "images"
  #     p.css_dir = "css"
  #     p.package_files.include("README.txt", "HISTORY.txt")
  #     p.package_dir = "build"
  #   end
  #
     
  class CompileTask < TaskLib

    # Name of the plugin files (don't add .js, eg 'jquery.mywidget').
    attr_accessor :name

    # Directory used to store the package files (default is 'images').
    attr_accessor :images_dir

    # Directory used to store the package files (default is 'css').
    attr_accessor :css_dir

    # Directory used to store the package files (default is 'build').
    attr_accessor :package_dir

    # True if the single js file is compiled using SED (default is true).
    attr_accessor :need_sed

    # True if the single js file is compressed using PACKER (default is true).
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
      init(name)
      yield self if block_given?
      define unless name.nil?
    end

    # Initialization that bypasses the "yield self" and "define" step.
    def init(name)
      @name = name
      @package_files = Rake::FileList["README.txt", "HISTORY.txt"]
      @package_dir = 'build'
      @need_sed = true
      @need_packer = true
      @images_dir = 'images'
      @css_dir = 'css'
      @js_dir = 'src'
      @js_files = Rake::FileList.new
      @js_files.include("#{@js_dir}/**/*.js")
      @image_files = Rake::FileList.new
      @image_files.include("#{@js_dir}/#{@image_dir}/**/*.*")
      @css_files = Rake::FileList.new
      @css_files.include("#{@js_dir}/#{@css_dir}/**/*.css")     
    end

    # Create the tasks defined by this task library.
    def define
      fail "Name required (or :noversion)" if @name.nil?
      @name = nil if :noname == @name
      

      desc "Build all the packages"
      task :compile => :pack do
        [images_dir, css_dir].each { |dir| mkdir_p("#{package_dir_path}/#{dir}") }
        FileUtils.cp(image_files, package_images_path)
        FileUtils.cp(css_files, package_css_path)
        FileUtils.cp(package_files, package_dir_path)
     end
      
      desc "Force a rebuild of the package files"
      task :recompile => [:clobber_compile, :compile]
      
      desc "Remove compile products" 
      task :clobber_compile do
        FileUtils.rm_r(package_dir_path) rescue nil
      end
      
      desc "Merge js files into one"
      task :merge do
        `#{sed_command}`
      end
      
      desc "Compress js files to min"
      task :pack => :merge do
        puts packer_command
        `#{packer_command}`
      end

      task :clobber => [:clobber_compile]

      self
    end
      
    def package_dir_path
      "#{package_dir}"
    end
    
    def package_css_path
      "#{package_dir_path}/#{css_dir}"
    end
    
    def package_images_path
      "#{package_dir_path}/#{images_dir}"
    end
    
    def package_js
      "#{package_dir_path}/#{name}.js"
    end

    def packed_js
      "#{package_dir_path}/#{name}.min.js"
    end
    
    def sed_command
      "sed -e '1 s/^\xEF\xBB\xBF//' #{js_files} > #{package_js}"
    end
    
    def packer_command
      "perl -I #{File.dirname(__FILE__)}/../packer #{File.dirname(__FILE__)}/../packer/jsPacker.pl -i #{package_js} -o #{packed_js} -e62"
    end

  end

end
