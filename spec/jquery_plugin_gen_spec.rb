require File.dirname(__FILE__) + '/spec_helper.rb'

describe "Base generation" do
    
  it "should be able to read in a template file" do
    details = {:version => '0.1.0', :project => 'email'}
    text = JqueryPluginGen::QuickTemplate.erb('Makefile', details)
  end
  
end
