require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'jqp/cli'

describe Jqp::CLI, "execute" do
  before(:each) do
    FileUtils.rm_rf(File.dirname(__FILE__) + '/../~jq-plugin') if File.directory? File.dirname(__FILE__) + '/../~jq-plugin'
    @stdout_io = StringIO.new
    Jqp::CLI.execute(@stdout_io, [])
    @stdout_io.rewind
    @stdout = @stdout_io.read
  end
  
  it "should print default output" do
    @stdout.should =~ /To update this executable/
  end
end