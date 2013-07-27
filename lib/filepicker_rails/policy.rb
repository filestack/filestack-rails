require 'base64'
require 'openssl'

module FilepickerRails
  class Policy
    attr_accessor :expiry, :call, :handle, :maxsize, :minsize, :path

    def initialize(options = {})
      [:expiry, :call, :handle, :maxsize, :minsize, :path].each do |input|
        send("#{input}=", options[input]) unless options[input].nil?
      end
    end

    def policy
      Base64.urlsafe_encode64(json_policy)
    end

    def signature
      OpenSSL::HMAC.hexdigest('sha256', ::Rails.application.config.filepicker_rails.secret_key, policy)
    end

    private
    def json_policy
      hash = Hash.new

      @expiry ||= Time.now.to_i + ::Rails.application.config.filepicker_rails.default_expiry

      [:expiry, :call, :handle, :maxsize, :minsize, :path].each do |input|
        hash[input] = send(input) unless send(input).nil?
      end

      MultiJson.dump(hash)
    end
  end
end
