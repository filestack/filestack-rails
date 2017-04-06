module FilepickerRails
  # @private
  module Tag

    FILEPICKER_OPTIONS_TO_DASHERIZE = [:button_text, :button_class, :mimetypes,
                                       :extensions, :container, :services,
                                       :drag_text, :drag_class, :store_path,
                                       :store_location, :store_access,
                                       :store_container, :multiple]

    FILEPICKER_OPTIONS_TO_CAMELIZE = [:max_size, :max_files, :open_to, :language]

    private
      attr_reader :input_options, :type

      def define_input_options(options)
        @type = options.delete(:dragdrop) ? 'filepicker-dragdrop' : 'filepicker'
        @input_options = retrieve_legacy_filepicker_options(options)
        @input_options['data-fp-apikey'] ||= ::Rails.application.config.filepicker_rails.api_key
        @input_options.merge!(secure_filepicker) unless @input_options['data-fp-policy'].present?
        @input_options['type'] = @type
        @input_options
      end

      def filepicker_prefix
        'data-fp-'
      end

      def retrieve_legacy_filepicker_options(options)
        mappings = {}
        FILEPICKER_OPTIONS_TO_DASHERIZE.each do |option|
          mappings[option] = "#{filepicker_prefix}#{option.to_s.dasherize}"
        end
        FILEPICKER_OPTIONS_TO_CAMELIZE.each do |option|
          mappings[option] = "#{filepicker_prefix}#{option.to_s.camelize(:lower)}"
        end
        Hash[options.map {|k, v| [mappings[k] || k, v] }]
      end

      def secure_filepicker
        Policy.apply(call: [:pick, :store], keys: ['data-fp-policy', 'data-fp-signature'])
      end
  end
end
