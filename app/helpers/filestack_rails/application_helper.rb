require 'json'
include FilestackRails::Transform
include FilestackRails::Version

module FilestackRails
  module ApplicationHelper
    def filestack_js_include_tag
      v2 = -> { javascript_include_tag('https://static.filestackapi.com/v3/filestack.js', type: 'text/javascript') }
      v3 = -> { javascript_include_tag('https://static.filestackapi.com/filestack-js/1.x.x/filestack.min.js', type: 'text/javascript') }

      get_filestack_js_result(v2: v2, v3: v3)
    end

    def filestack_js_init_tag
      client_name, apikey = get_client_and_api_key
      signature_and_policy = get_policy_and_signature_string
      javascript_string = "var #{client_name} = filestack.init('#{apikey}', #{signature_and_policy}, '#{cname}');"
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
      transform_object = options[:transform]
      options.delete(:transform)
      if transform_object
        transform_object.add_external_url url
        image_tag transform_object.fs_url, options
      else
        image_tag url
      end
    end

    private

    def cname
      ::Rails.application.config.filestack_rails.cname
    end

    def create_javascript_for_picker(callback, options)
      client_name, _api_key = get_client_and_api_key
      json_string = if options.nil?
                      ''
                    else
                      options.to_json
                    end
      v2 = -> do
        <<~HTML
          (function(){
            #{client_name}.pick(#{json_string}).then(function(data){#{callback}(data)})
          })()
        HTML
      end

      v3 = -> do
        json_string = json_string[1..-2] # removed curly brackets help to generate pickerOptions in js

        <<~HTML
          (function(){
            #{client_name}.picker({ onUploadDone: data => #{callback}(data), #{json_string} }).open()
          })()
        HTML
      end
      get_filestack_js_result(v2: v2, v3: v3)
    end

    def get_client_and_api_key
      client_name = ::Rails.application.config.filestack_rails.client_name
      apikey = ::Rails.application.config.filestack_rails.api_key
      [client_name, apikey]
    end

    def get_policy_and_signature
      if ::Rails.application.config.filestack_rails.security
        signature = ::Rails.application.config.filestack_rails.security.signature
        policy = ::Rails.application.config.filestack_rails.security.policy
      else
        signature = nil
        policy = nil
      end
      return [signature, policy]
    end

    def get_policy_and_signature_string
      signature, policy = get_policy_and_signature

      if policy && signature
        signature_and_policy = { signature: signature, policy: policy }
        v2 = -> { signature_and_policy.to_json }
        v3 = -> { { security: signature_and_policy }.to_json }
        get_filestack_js_result(v2: v2, v3: v3)
      else
        "''"
      end
    end
  end
end
