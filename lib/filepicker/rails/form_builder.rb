module Filepicker
  module Rails
    module FormBuilder

      def filepicker_field(method, options = {})
        type = options.delete(:dragdrop) ? 'filepicker-dragdrop' : 'filepicker'

        input_options = retrive_legacy_filepicker_options(options)
        input_options['data-fp-apikey'] ||= ::Rails.application.config.filepicker_rails.api_key
        input_options.merge!(secure_filepicker) unless input_options['data-fp-policy'].present?

        ActionView::Helpers::InstanceTag.new(@object_name, method, @template)
          .to_input_field_tag(type, input_options)
      end

      private

      def retrive_legacy_filepicker_options(options)
        mappings = {
            :button_text  => 'data-fp-button-text',
            :button_class => 'data-fp-button-class',
            :mimetypes    => 'data-fp-mimetypes',
            :container    => 'data-fp-container',
            :services     => 'data-fp-services',
            :drag_text    => 'data-fp-drag-text',
            :drag_class   => 'data-fp-drag-class',
            :onchange     => 'onchange',
            :class        => 'class',
            :value        => 'value'
        }

        Hash[options.map {|k, v| [mappings[k] || k, v] }]
      end

      def secure_filepicker
        return {} unless ::Rails.application.config.filepicker_rails.secret_key.present?
        grant = Policy.new
        grant.expiry = Time.now.to_i + ::Rails.application.config.filepicker_rails.default_expiry
        grant.call = [:pick, :store]

        {
            'data-fp-policy' => grant.policy,
            'data-fp-signature' => grant.signature
        }
      end
    end
  end
end
