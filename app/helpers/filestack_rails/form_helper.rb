module FilestackRails
  module FormHelper
    include FilestackRails::ApplicationHelper
    include ActionView::Helpers
    def filestack_field(method, content, options = {})
      get_filestack_field_button(method, content, options)
    end

    private

    def get_filestack_field_button(method, content, options = {})
      input_options = {}
      input_options[:id] = "#{@object.class.name.downcase}_#{method.downcase}"
      input_options[:style] = 'display:none'
      user_callback = options[:callback] || nil
      options.delete(:callback)

      form_field_callback_guts = 'const filestack_input_field' \
        "= document.getElementById('#{input_options[:id]}');" \
        'filestack_input_field.value = data.filesUploaded[0].url;'

      unless user_callback.nil?
        form_field_callback_guts = "#{form_field_callback_guts}#{user_callback}(data)"
      end
      
      form_field_callback = "(function(data){#{form_field_callback_guts}})"

      html_string = "#{filestack_picker_element(content, form_field_callback, options)}#{text_field(method, input_options)}"
      raw html_string.html_safe
    end
  end
end
