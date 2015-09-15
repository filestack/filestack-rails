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

    def self.apply(call = [:read, :convert], keys = ['policy', 'signature'])
      return {} unless ::Rails.application.config.filepicker_rails.secret_key.present?
      grant = Policy.new
      grant.call = call
      {
        keys[0] => grant.policy,
        keys[1] => grant.signature
      }
    end

    private
    def json_policy
      hash = Hash.new

      @expiry ||= ::Rails.application.config.filepicker_rails.expiry.call

      [:expiry, :call, :handle, :maxsize, :minsize, :path].each do |input|
        hash[input] = send(input) unless send(input).nil?
      end

      hash.to_json
    end
  end
end
