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
    config.filestack_rails.client_name = 'filestack_client'

    # config.filestack_rails.version = '3.x.x'
    # config.filestack_rails.app_secret = 'APP_SECRET'
    # config.filestack_rails.security = {call: %w[read store pick stat write writeUrl convert remove exif], expiry: 60}
    # config.filestack_rails.cname = "fs.agorize.com"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
