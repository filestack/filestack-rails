require 'base64'
require 'openssl'

# Generate a policy and signature from the given options
#
# #### Constructor
#
# @param [Hash] options
# @option options [Fixnum] :expiry        Time that url will expire in seconds
#       since the Epoch
#
# @option options [Array] :call          Array of permissions to allow in the
#       policy.
#
#       - `:pick`
#       - `:read`
#       - `:stat`
#       - `:write`
#       - `:writeUrl`
#       - `:store`
#       - `:convert`
#       - `:remove`
#
# @option options [String] :handle        The unique file handle that you would
#       like to access. A Filepicker file URL like https://www.filepicker.io/api/file/KW9EJhYtS6y48Whm2S6D
#       has a handle of KW9EJhYtS6y48Whm2S6D. This is for all calls that act on
#       a specific handle. Pick is not affected by this input as no handle
#       exists yet for the file.
#
# @option options [Fixnum] :maxsize       The maximum size that can be stored
#       into your s3. This only applies to the store command. Default to no limit.
#
# @option options [Fixnum] :minsize       The minimum size that can be stored
#       into your s3. This only applies to the store command. Together with
#       maxSize, this forms a range. The value of minSize should be smaller
#       then maxSize. Default to 0.
#
# @option options [String] :path          For policies that store files, a
#       perl-like regular expression that must match the path that the files
#       will be stored under. Defaults to allowing any path ('.*').
#
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
