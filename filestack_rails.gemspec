$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'filepicker_rails/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'filestack-rails'
  s.version     = FilepickerRails::VERSION
  s.authors     = ['Filestack']
  s.email       = ['dev@filestack.com']
  s.homepage    = 'https://github.com/filestack/filestack-rails'
  s.summary     = 'Makes integrating Filestack with rails easy'
  s.description = 'Makes integrating Filestack with rails easy'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '>= 3.2'

  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'yard'
end
