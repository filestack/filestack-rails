module FilestackRails
  class Configuration
    attr_accessor :api_key, :client_name, :secret_key, :security, :expiry, :app_secret, :cname

    def api_key
      @api_key or raise "Set config.filestack_rails.api_key"
    end

    def client_name
      @client_name or 'filestack_client'
    end

    def expiry
      @expiry or ( Time.zone.now.to_i + 600 )
    end

    def security=(security_options = {})
      if @app_secret.nil?
        raise 'You must have secret key to use security'
      end
      @security = FilestackSecurity.new(@app_secret, options: security_options)
    end

  end
end
