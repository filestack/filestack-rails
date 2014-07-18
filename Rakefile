begin
  require 'bundler/setup'
  require 'appraisal'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rspec/core/rake_task'
require 'rdoc/task'

RSpec::Core::RakeTask.new

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'FilepickerRails'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

task :default do
  if ENV['BUNDLE_GEMFILE'] =~ /gemfiles/
    Rake::Task['spec'].invoke
  else
    Rake::Task['appraise'].invoke
  end
end

task :appraise do
  exec 'appraisal install && appraisal rake'
end

Bundler::GemHelper.install_tasks

