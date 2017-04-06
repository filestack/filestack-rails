ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../dummy/config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each { |f| require f }

if RailsVersions.rails_4_1_x_up?
  ActiveRecord::Migration.maintain_test_schema!
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.render_views
end
