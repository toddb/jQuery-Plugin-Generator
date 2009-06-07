desc "Run acceptance test in browser"
task :acceptance => :compile do
  `open test/acceptance.html`
end

desc "Run spec tests in browser"
task :specs do
  `open test/specs.html`
end

desc "Show example"
task :example => :merge do
  `open example.html`
end

desc "Show all browser examples and tests"
task :show => [:specs, :acceptance, :example]

desc "First time run to demonstrate that pages are working"
task :first_time => ['jquery:add', :show]