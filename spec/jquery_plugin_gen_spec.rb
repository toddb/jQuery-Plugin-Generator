require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Base generation" do
  
  before(:each) do
  end
  
  after(:each) do
  end
  
  %w(Makefile History.txt README.txt Rakefile).each do |file|
    it "should generate the #{file}" do
      JqueryPluginGen::QuickTemplate.erb(file, details).should == generated_file(file)
    end
  end

  %w(src/email.js test/spec_email.js test/specs.html).each do |file|
    it "should transform the #{file}" do
      JqueryPluginGen::QuickTemplate.erb(file.gsub(/email/, 'plugin'), details).should == generated_file(file)
    end
  end
 
end
