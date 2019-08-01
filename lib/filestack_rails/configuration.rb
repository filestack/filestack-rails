require 'net/http'

module FilestackRails
  class Configuration
    attr_accessor :api_key, :client_name, :secret_key, :security, :expiry, :app_secret, :cname, :version

    OUTDATED_VERSION = '0.11.5'

    def api_key
      @api_key or raise "Set config.filestack_rails.api_key"
    end

    def client_name
      @client_name or 'filestack_client'
    end

    def version
      @version or '3.x.x'
    end

    def expiry
      @expiry or ( Time.zone.now.to_i + 600 )
    end

    def security=(security_options = {})
      if @app_secret.nil?
        raise 'You must have secret key to use security'
      end
      @security = security_options
    end

    def app_secret
      @app_secret or nil
    end
  end
end
