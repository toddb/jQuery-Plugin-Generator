require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'jqp/cli'

describe Jqp::CLI, "execute" do
  before(:each) do
    @stdout_io = StringIO.new
    Jqp::CLI.execute(@stdout_io, [''])
    @stdout_io.rewind
    @stdout = @stdout_io.read
  end
  
  after(:each) do
    FileUtils.rm_rf(base_dir) if File.directory? base_dir    
  end
  
  it "should print default output" do
    @stdout.should =~ /To update this executable/
  end

  it "should be able to create base directories" do
    %w(src lib test dist src/images src/css test/data).each do |dir| 
      File.directory?(base_dir + dir).should equal(true)
    end
  end 
  
  it "should be able to create base file" do
    base_files.each do |file| 
      File.exists?(base_dir + file).should equal(true)
    end
    
  end
  
  def base_files
    %w(Makefile History.txt README.txt Rakefile Manifest.txt 
      src/~jq-plugin.js test/spec_~jq-plugin.js src/css/screen.~jq-plugin.css 
      test/specs.html test/data/~jq-plugin_01.js test/data/~jq-plugin_01.json)  
  end
end