module FilepickerRails
  module FormHelper

    # Creates a filepicker field, accepts optional `options` hash for configuration.
    #
    # #### Options
    #
    # - `:button_text` - The text of the upload button.
    # - `:button_class` - The class of the upload button.
    # - `:extensions` - The extensions of file types you want to support for this upload. Ex: `.png,.jpg`.
    # - `:mimetypes` - The file types you want to support for this upload. Ex: `image/png,text/*`.
    # - `:container` - Where to show the file picker dialog can be `modal`, `window` or the id of an iframe on the page.
    # - `:multiple` - (true or false) Whether or not multiple uploads can be saved at once.
    # - `:services` - What services your users can upload to. Ex: `BOX, COMPUTER, FACEBOOK`.
    # - `:store_path` - The path to store the file at within the specified file store.
    # - `:store_location` - The file is not copied by default. It remains in the original location. If you wish you have the file copied onto your own storage, you can specify where we should put the copy. The only value at the moment is `S3`.
    # - `:store_access` - Should the underlying file be publicly available on its S3 link. Options are `public` and `private`, defaults to 'private'.
    # - `:dragdrop` - (`true` or `false`) Whether or not to allow drag-and-drop uploads.
    # - `:drag_text` - The text of the dragdrop pane.
    # - `:drag_class` - The class of the dragdrop pane.
    # - `:onchange` - The onchange event.
    # - `:max_size` - The maximum file size allowed, in bytes.
    # - `:class` - Add a class to the input.
    # - `:value` - Define the value of the input
    #
    # #### Examples
    #
    #     filepicker_field(:filepicker_url)
    #     # => <input data-fp-apikey="..." id="user_filepicker_url" name="user[filepicker_url]" type="filepicker" />
    #
    # This is mixed on form for to be used like.
    #
    #     <%= form_for @user do |f| %>
    #       <%= f.filepicker_field :filepicker_url %>
    #       <%= f.submit %>
    #     <% end %>
    #
    def filepicker_field(method, options = {})
      define_input_options(options)
      @method = method
      if rails_greater_than_4?
        rails_greater_than_4_input
      else
        rails_input
      end
    end

    private

      attr_reader :input_options, :method, :type, :object_name, :template

      def define_input_options(options)
        @type = options.delete(:dragdrop) ? 'filepicker-dragdrop' : 'filepicker'
        @input_options = retrieve_legacy_filepicker_options(options)
        @input_options['data-fp-apikey'] ||= ::Rails.application.config.filepicker_rails.api_key
        @input_options.merge!(secure_filepicker) unless @input_options['data-fp-policy'].present?
        @input_options['type'] = @type
        @input_options
      end

      def rails_greater_than_4_input
        tag = ActionView::Helpers::Tags::TextField.new(object_name, method, template, objectify_options(input_options))
        tag.send(:add_default_name_and_id, input_options)
        tag.render
      end

      def rails_input
        ActionView::Helpers::InstanceTag.new(object_name, method, template).to_input_field_tag(type, input_options)
      end

      def rails_greater_than_4?
        ::Rails.version.to_i >= 4
      end

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
        Policy.apply([:pick, :store], ['data-fp-policy', 'data-fp-signature'])
      end
  end
end
