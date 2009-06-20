require 'rubygems' unless ENV['NO_RUBYGEMS']
%w[rake rake/clean fileutils newgem rubigen].each { |f| require f }
require File.dirname(__FILE__) + '/lib/jquery_plugin_gen'

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.new('jqueryplugingen', JqueryPluginGen::VERSION) do |p|
  p.developer('toddb', 'todd@8wireunlimited.com')
  p.changes              = p.paragraphs_of("History.txt", 0..1).join("\n\n")
  p.rubyforge_name       = 'jqueryplugingen' 
  p.description          = "Generate the structure of jquery plugins easily. Manage library dependencies such as other jquery libraries or packing code on either mac or windows. Get jsspec testing baked in.  Use the familiar rake tasks to manage your jquery code base."
  p.extra_deps         = [
    ['simple-rss','>= 1.2'],
  ]

  # p.extra_dev_deps = [
  #   ['newgem', ">= #{::Newgem::VERSION}"]
  # ]
  
  p.clean_globs |= %w[**/.DS_Store tmp *.log]
  path = (p.rubyforge_name == p.name) ? p.rubyforge_name : "\#{p.rubyforge_name}/\#{p.name}"
  p.remote_rdoc_dir = File.join(path.gsub(/^#{p.rubyforge_name}\/?/,''), 'rdoc')
  p.rsync_args = '-av --delete --ignore-errors'
end

require 'newgem/tasks' # load /tasks/*.rake
Dir['tasks/**/*.rake'].each { |t| load t }

# TODO - want other tests/tasks run by default? Add them to the list
task :default => [:show]
