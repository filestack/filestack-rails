module FilepickerRails
  module FormHelper

    def filepicker_field(method, options = {})
      type = options.delete(:dragdrop) ? 'filepicker-dragdrop' : 'filepicker'

      input_options = retrieve_legacy_filepicker_options(options)
      input_options['data-fp-apikey'] ||= ::Rails.application.config.filepicker_rails.api_key
      input_options.merge!(secure_filepicker) unless input_options['data-fp-policy'].present?
      input_options['type'] = type

      if ::Rails.version.to_i >= 4
        tag = ActionView::Helpers::Tags::TextField.new(@object_name, method, @template, objectify_options(input_options))
        tag.send(:add_default_name_and_id, input_options)
        tag.render
      else
        ActionView::Helpers::InstanceTag.new(@object_name, method, @template).to_input_field_tag(type, input_options)
      end
    end

    private

      def retrieve_legacy_filepicker_options(options)
        mappings = {
            :button_text    => 'data-fp-button-text',
            :button_class   => 'data-fp-button-class',
            :mimetypes      => 'data-fp-mimetypes',
            :extensions     => 'data-fp-extensions',
            :container      => 'data-fp-container',
            :services       => 'data-fp-services',
            :drag_text      => 'data-fp-drag-text',
            :drag_class     => 'data-fp-drag-class',
            :store_path     => 'data-fp-store-path',
            :store_location => 'data-fp-store-location',
            :store_access   => 'data-fp-store-access',
            :multiple       => 'data-fp-multiple',
            :max_size       => 'data-fp-maxSize',
            :onchange       => 'onchange',
            :class          => 'class',
            :value          => 'value'
        }

        Hash[options.map {|k, v| [mappings[k] || k, v] }]
      end

      def secure_filepicker
        return {} unless ::Rails.application.config.filepicker_rails.secret_key.present?
        grant = Policy.new
        grant.call = [:pick, :store]

        {
            'data-fp-policy' => grant.policy,
            'data-fp-signature' => grant.signature
        }
      end
  end
end
