module FilestackRails
  module FormHelper
    include FilestackRails::ApplicationHelper
    include ActionView::Helpers
    def filestack_field(method, content, options = {})
      get_filestack_field_button(method, content, options)
    end

    private 

      def get_filestack_field_button(method, content, options = {})
        options[:id] = options[:id] || "#{@object.class.name.downcase}_#{method.downcase}"
        options[:style] = 'display:none'
        user_callback = options[:callback] || nil

        form_field_callback_guts = "const filestack_input_field = document.getElementById('#{options[:id]}');" \
          "filestack_input_field.value = data.filesUploaded[0].url;"
        form_field_callback_guts = "#{form_field_callback_guts}#{user_callback}(data)" unless user_callback.nil?                      
        form_field_callback = "(function(data){#{form_field_callback_guts}})"

        html_string = "#{filestack_picker_element("#{content}", form_field_callback)}#{text_field(method, options)}"
        raw html_string.html_safe
      end
  end
end