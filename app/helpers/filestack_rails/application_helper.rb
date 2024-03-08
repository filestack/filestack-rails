require 'json'
include FilestackRails::Transform
include FilestackRails::FilestackJs

module FilestackRails
  module ApplicationHelper
    def filestack_js_include_tag
      javascript_include_tag(get_filestack_js.url, type: 'text/javascript')
    end

    def filestack_js_init_tag
      client_name, apikey = get_client_and_api_key
      javascript_string =
        if filestack_js_v3?
          options = { cname: cname }
          policy, signature = get_policy_and_signature
          if policy && signature
            options[:security] = {
              policy: policy,
              signature: signature
            }
          end
          "var #{client_name} = filestack.init('#{apikey}', #{options.to_json});"
        else
          signature_and_policy = get_policy_and_signature_string
          "var #{client_name} = filestack.init('#{apikey}', #{signature_and_policy}, '#{cname}');"
        end
      javascript_tag javascript_string
    end

    def filestack_picker_element(content, callback, options = {})
      picker_options = options[:pickerOptions]
      options.delete(:pickerOptions)
      options[:onclick] = create_javascript_for_picker(callback, picker_options)
      options[:type] = 'button'
      button_tag content, options
    end

    def filestack_transform
      _, apikey = get_client_and_api_key
      get_transform(apikey)
    end

    def filestack_image(url, options = {})
      transform_object = options.delete(:transform)

      image_tag(filestack_image_url(url, transform_object), options)
    end

    def filestack_image_url(url, transform_object = nil)
      return url unless transform_object
      transform_object.add_external_url(url)
      transform_object.fs_url
    end

    private

    def filestack_js_v3?
      get_filestack_js.version.to_s[0] == '3'
    end

    def cname
      ::Rails.application.config.filestack_rails.cname
    end

    def create_javascript_for_picker(callback, options)
      client_name, api_key = get_client_and_api_key
      other_callbacks = build_callbacks_js(options) if options
      options = if options.nil?
                  ''
                else
                  options.to_json
                end

      get_filestack_js.picker(client_name, api_key, options, callback, other_callbacks)
    end

    def build_callbacks_js(options)
      string = ''
      string << ", onOpen: data => #{options.delete(:onOpen)}(data)" unless options[:onOpen].blank?
      string << ", onCancel: data => #{options.delete(:onCancel)}(data)" unless options[:onCancel].blank?
      string << ", onClose: () => #{options.delete(:onClose)}()" unless options[:onClose].blank?
      string << ", onFileUploadProgress: data => #{options.delete(:onFileUploadProgress)}(data)" unless options[:onFileUploadProgress].blank?
      string << ", onFileSelected: data => #{options.delete(:onFileSelected)}(data)" unless options[:onFileSelected].blank?
      string << ", onUploadStarted: data => #{options.delete(:onUploadStarted)}(data)" unless options[:onUploadStarted].blank?
      string << ", onUploadDone: data => #{options.delete(:onUploadDone)}(data)" unless options[:onUploadDone].blank?
      string << ", onFileUploadFinished: data => #{options.delete(:onFileUploadFinished)}(data)"   unless options[:onFileUploadFinished].blank?
      string << ", onFileUploadFailed: data => #{options.delete(:onFileUploadFailed)}(data)"  unless options[:onFileUploadFailed].blank?
      string << ", onFileUploadStarted: data => #{options.delete(:onFileUploadStarted)}(data)" unless options[:onFileUploadStarted].blank?
      string
    end

    def get_client_and_api_key
      client_name = ::Rails.application.config.filestack_rails.client_name
      apikey = ::Rails.application.config.filestack_rails.api_key
      [client_name, apikey]
    end

    def get_policy_and_signature
      if security
        signature = security.signature
        policy = security.policy
      end
      [policy, signature]
    end

    def get_policy_and_signature_string
      policy, signature = get_policy_and_signature

      if policy && signature
        get_filestack_js.security(signature, policy)
      else
        "''"
      end
    end

    def security
      security_options = ::Rails.application.config.filestack_rails.security
      app_secret = ::Rails.application.config.filestack_rails.app_secret

      return nil unless security_options
      FilestackSecurity.new(app_secret, options: security_options)
    end
  end
end
