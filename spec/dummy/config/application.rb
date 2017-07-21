require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require 'filestack_rails'

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.assets.compile = true
    config.filestack_rails.api_key = 'API_KEY'
    config.filestack_rails.client_name = 'rich_client'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
