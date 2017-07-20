include FilestackRails::Transform

module FilestackRails
  module ApplicationHelper

    def filestack_js_include_tag
      javascript_include_tag "https://static.filestackapi.com/v3/filestack.js", type: "text/javascript"
    end

    def filestack_js_init_tag
      client_name, apikey = get_client_and_api_key
      javascript_string = "var #{client_name} = filestack.init('#{apikey}');"
      javascript_tag javascript_string
    end

    def filestack_picker_element(content, callback, options = {})
      button_tag content, onclick: create_javascript_for_picker(callback, options), type: 'button'
    end 

    def filestack_transform
      _, apikey = get_client_and_api_key
      get_transform(apikey)
    end

    def filestack_image(url, options = {})
      transform_object = options[:transform]
      if transform_object
        transform_object.add_external_url url
        image_tag transform_object.url, options
      else
        image_tag url
      end
    end
    
    private 

    def create_javascript_for_picker(callback, options)
      client_name, apikey = get_client_and_api_key
      json_string = if options.nil? 
                      ''
                    else 
                      options.to_json
                    end
      "(function(){
        #{client_name}.pick(#{json_string}).then(function(data){#{callback}(data)})
      })()"
    end

    def get_client_and_api_key
      client_name = ::Rails.application.config.filestack_rails.client_name
      apikey = ::Rails::application.config.filestack_rails.api_key
      [client_name, apikey]
    end

  end
end
