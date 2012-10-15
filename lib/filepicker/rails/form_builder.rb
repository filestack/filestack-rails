module Filepicker
  module Rails
    module FormBuilder

      def filepicker_field(method, options = {})
        input_options = {
          'data-fp-apikey' =>
          ::Rails.application.config.filepicker_rails.api_key,

          'data-fp-button-text' => options.fetch(:button_text, "Pick File"),

          'data-fp-button-class' => options[:button_class],

          'data-fp-mimetypes' => options[:mimetypes],

          'data-fp-option-container' => options[:container],

          'data-fp-option-multiple' => false,

          'data-fp-option-services' => Array(options[:services]).join(","),
          
          'value' => options[:value]
        }

        type = options[:dragdrop] ? 'filepicker-dragdrop' : 'filepicker'

        ActionView::Helpers::InstanceTag.new(@object_name, method, @template)
          .to_input_field_tag(type, input_options)
      end
    end
  end
end
