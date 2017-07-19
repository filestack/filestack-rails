module FilestackRails
  module FormHelper

    def filestack_field(method, options = {})
      get_filestack_field_button(method, options)
    end

    private 

      def get_filestack_field_button(method, options)
        # TODO: add filestack_field button
      end

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