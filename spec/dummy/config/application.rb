require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require 'filestack-rails'

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    # config.load_defaults 5.1
    config.assets.compile = true
    config.filestack_rails.api_key = 'API_KEY'
    config.filestack_rails.client_name = 'rich_client'
    # config.filestack_rails.version = 'v3'
    # config.filestack_rails.app_secret = '22VXWDDDDDDQXBJA63X637JLIA'
    # config.filestack_rails.security = {call: %w[read store pick stat write writeUrl convert remove exif], expiry: 60}

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
