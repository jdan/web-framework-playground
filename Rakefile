# frozen_string_literal: true

require 'rake'
require 'rspec/core/rake_task'
require 'rdoc/task'
require 'rubocop/rake_task'

# rake test
RSpec::Core::RakeTask.new(:test)

# rake rdoc
RDoc::Task.new :rdoc do |rdoc|
  rdoc.main = 'README.rdoc'
  rdoc.rdoc_dir = 'doc'
  rdoc.rdoc_files.include('README.rdoc', 'src/**/*.rb')
end

# rake lint
RuboCop::RakeTask.new(:lint)

namespace :run do
  desc 'Run an example web server with basic routing'
  task :basic do
    sh 'ROUTING=basic rackup'
  end

  desc 'Run an example web server with sinatra style routing'
  task :sinatra do
    sh 'ROUTING=sinatra rackup'
  end

  desc 'Run an example web server with hanami style routing'
  task :hanami do
    sh 'ROUTING=hanami rackup'
  end

  desc 'Run an example web server with camping style routing'
  task :camping do
    sh 'ROUTING=camping rackup'
  end
end
