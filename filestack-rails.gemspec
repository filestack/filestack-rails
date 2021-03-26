$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "filestack_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "filestack-rails"
  s.version     = FilestackRails::VERSION
  s.authors     = ["filestack"]
  s.email       = ["dev@filestack.com"]
  s.homepage    = "https://www.filestack.com"
  s.summary     = "Filestack plugin for Rails 4+"
  s.description = "Allows easy integraiton of Filestack's File Picker through dynamic button tags and form helpers"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency 'rails', '>= 4.0'
  s.add_dependency "filestack", '~> 2.9.1'

  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'sqlite3', '~> 1.3', '>= 1.3.6'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'appraisal'
end
