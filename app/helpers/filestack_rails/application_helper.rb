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
      client_name, = get_client_and_api_key
      callbacks_js = build_callbacks_js(options)
      json_string = if options.nil?
                      ''
                    else
                      options.to_json
                    end
      v2 = -> { "(function(){
        #{client_name}.pick(#{json_string}).then(function(data){#{callback}(data)})
      })()" }

      v3 = -> { json_string = "#{json_string}".slice!(1, json_string.length-2) # removed curly brackets help to generate pickerOptions in js
                "(function(){
                  #{client_name}.picker({#{json_string}, onUploadDone: data => #{callback}(data)#{callbacks_js}}).open()
                })()" }
      get_filestack_js_result(v2: v2, v3: v3)
    end

    def build_callbacks_js(options)
      string = ""
      string << ", onOpen: picker => #{options.delete(:onOpen)}(picker)" unless options[:onOpen].blank?
      string << ", onClose: () => #{options.delete(:onClose)}()" unless options[:onClose].blank?
      string << ", onFileUploadFinished: file => #{options.delete(:onFileUploadFinished)}(file)" unless options[:onFileUploadFinished].blank?
      string << ", onFileSelected: file => #{options.delete(:onFileSelected)}(file)" unless options[:onFileSelected].blank?
      string << ", onUploadStarted: files => #{options.delete(:onUploadStarted)}(files)" unless options[:onUploadStarted].blank?
      string
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
      return "{'signature': '#{signature}', 'policy': '#{policy}'}" if policy && signature
      return "''"
    end
  end
end
