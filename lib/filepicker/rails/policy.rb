require 'base64'
require 'openssl'

module Filepicker
  module Rails
    class Policy
      attr_accessor :expiry, :call, :handle, :maxsize, :minsize

      def policy
        Base64.urlsafe_encode64(json_policy)
      end

      def signature
        OpenSSL::HMAC.hexdigest('sha256', ::Rails.application.config.filepicker_rails.secret_key, policy)
      end

      private
      def check_required!
        @expiry or raise 'Expiration date not provided'
      end

      def json_policy
        check_required!

        hash = Hash.new

        [:expiry, :call, :handle, :maxsize, :minsize].each do |input|
          hash[input] = send(input) unless send(input).nil?
        end

        MultiJson.dump(hash)
      end
    end
  end
end