module FilepickerRails
  class Configuration
    attr_writer :api_key
    attr_accessor :secret_key, :cdn_host

    def api_key
      @api_key or raise "Set config.filepicker_rails.api_key"
    end

    def expiry=(expiry)
      raise ArgumentError, 'Must be a callable' unless expiry.respond_to?(:call)
      @expiry = expiry
    end

    def expiry
      @expiry ||= -> { Time.zone.now.to_i + 600 }
    end
  end
end
