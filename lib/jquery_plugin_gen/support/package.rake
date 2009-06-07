begin
  %w[rake/packagetask].each { |f| require f }
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  %w[rake/packagetask].each { |f| require f }
end

desc "Package"
Rake::PackageTask.new(JQUERY_PLUGIN, PLUGIN_VERSION) do |p|
  p.need_tar = true
  p.need_zip = true
  p.package_files.include("build/**/*.*")
end
