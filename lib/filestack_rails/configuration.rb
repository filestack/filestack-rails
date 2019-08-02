require 'net/http'

module FilestackRails
  OUTDATED_VERSION = '0.11.5'

  class Configuration
    attr_accessor :api_key, :client_name, :secret_key, :security, :expiry, :app_secret, :cname, :version

    def api_key
      @api_key or raise "Set config.filestack_rails.api_key"
    end

    def client_name
      @client_name or 'filestack_client'
    end

    def version
      @version ||= '3.x.x'

      raise 'Incorrect config.filestack_rails.version' unless version_exists?
      @version
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

    def url
      @url
    end

    def version_exists?
      @url = filestack_js_url

      if @version == OUTDATED_VERSION
        @url = outdated_filestack_js_url
      end

      url_exists?(@url)
    end

    def url_exists?(url)
      uri = URI(url)
      request = Net::HTTP.new(uri.host)
      response = request.request_head(uri.path)
      response.code.to_i == 200
    rescue
      raise 'Invalid URI'
    end

    def outdated_filestack_js_url
      'https://static.filestackapi.com/v3/filestack.js'
    end

    def filestack_js_url
      "https://static.filestackapi.com/filestack-js/#{@version}/filestack.min.js"
    end
  end
end
