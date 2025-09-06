require 'rake'
require 'rspec/core/rake_task'
require 'rdoc/task'

# rake test
RSpec::Core::RakeTask.new(:test)

# rake rdoc
RDoc::Task.new :rdoc do |rdoc|
  rdoc.main = 'README.rdoc'
  rdoc.rdoc_dir = 'doc'
end
