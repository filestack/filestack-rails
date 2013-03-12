require 'base64'
require 'digest/sha2'

module Filepicker
  module Rails
    class Policy
      attr_accessor :expiry, :call, :handle, :maxsize, :minsize

      def policy
        Base64.urlsafe_encode64(json_policy)
      end

      def signature
        signature = Digest::SHA2.new
        signature.update(json_policy)
        signature.to_s
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