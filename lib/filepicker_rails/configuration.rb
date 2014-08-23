module FilepickerRails
  class Configuration

    # Define your API Key to be used.
    #
    # #### Examples
    #
    # This is to be used on the `config/application.rb`:
    #
    #      config.filepicker_rails.api_key = 'Your filepicker.io API Key'
    #
    attr_writer :api_key

    # Define your Secret key to be used on Policy.
    #
    # More info about Policy on [Ink documentation](https://developers.filepicker.io/docs/security/)
    #
    # #### Examples
    #
    # This is to be used on the `config/application.rb`:
    #
    #      config.filepicker_rails.secret_key = 'Your filepicker.io Secret Key'
    #
    attr_writer :secret_key

    # @private
    attr_reader :secret_key

    # Set your CDN Path to be used
    #
    # More info about CDN on [Ink documentation](https://developers.filepicker.io/docs/cdn/)
    #
    # #### Examples
    #
    # This is to be used on the `config/application.rb`:
    #
    #      config.filepicker_rails.cdn_host = 'Your CDN host name'
    #
    attr_writer :cdn_host

    # @private
    attr_reader :cdn_host

    # @private
    def api_key
      @api_key or raise "Set config.filepicker_rails.api_key"
    end

    # Define the expire time when using Policy.
    #
    # By default the expiry time is 10 minutes.
    # If you need to change the expiry time this should be an integer and
    # it is expressed in seconds since the [Epoch](http://en.wikipedia.org/wiki/Unix_time).
    #
    # #### Examples
    #
    # This is to be used on the `config/application.rb`:
    #
    #      config.filepicker_rails.expiry = -> { (Time.zone.now + 5.minutes).to_i }
    #      # Define the expiry time to 5 minutes
    #
    # If you need always the same url, a static expiry time, to do some cache.
    # You can set a date starting of the Epoch.
    #
    #     config.filepicker_rails.expiry = -> { 100.years.since(Time.at(0)).to_i }
    #
    def expiry=(expiry)
      raise ArgumentError, 'Must be a callable' unless expiry.respond_to?(:call)
      @expiry = expiry
    end

    # @private
    def expiry
      @expiry ||= -> { Time.zone.now.to_i + 600 }
    end
  end
end
