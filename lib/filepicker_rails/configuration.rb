module FilepickerRails
  class Configuration
    attr_writer :api_key, :default_expiry, :policy_proc
    attr_accessor :secret_key, :cdn_host

    def api_key
      @api_key or raise "Set config.filepicker_rails.api_key"
    end

    def default_expiry
      @default_expiry ||= 600
    end

    def policy_proc
      @policy_proc || Proc.new { Policy.new(call: [:read, :convert]) }
    end
  end
end
