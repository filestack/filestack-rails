module FilepickerRails
  module ApplicationHelper

    include FilepickerRails::Tag

    # Creates a javascript tag to the filepicker JavaScript.
    #
    # #### Examples
    #
    #     filepicker_js_include_tag
    #     # => <script src="//api.filepicker.io/v1/filepicker.js"></script>
    def filepicker_js_include_tag
      javascript_include_tag "//api.filepicker.io/v2/filepicker.js", type: "text/javascript"
    end

    # Creates a filepicker field tag, accepts optional `options` hash for configuration.
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
    # - `:store_container` - The bucket or container in your specified `store_location`. Defaults to the container specified in the developer portal. Does not apply to Dropbox storage.
    # - `:store_access` - Should the underlying file be publicly available on its S3 link. Options are `public` and `private`, defaults to 'private'.
    # - `:dragdrop` - (`true` or `false`) Whether or not to allow drag-and-drop uploads.
    # - `:drag_text` - The text of the dragdrop pane.
    # - `:drag_class` - The class of the dragdrop pane.
    # - `:onchange` - The onchange event.
    # - `:max_size` - The maximum file size allowed, in bytes.
    # - `:max_files` - The maximum number of files.
    # - `:open_to` - Open the picker to the given service. Ex: `COMPUTER`.
    # - `:class` - Add a class to the input.
    # - `:value` - Define the value of the input
    #
    # #### Examples
    #
    #     filepicker_field_tag('user[filepicker_url]')
    #     # => <input data-fp-apikey="..." id="user_filepicker_url" name="user[filepicker_url]" type="filepicker" />
    #
    def filepicker_field_tag(name, options = {})
      define_input_options(options)
      tag :input, { 'type' => type, 'name' => name, 'id' => sanitize_to_id(name) }.update(input_options.stringify_keys)
    end

    # Creates a button allowing the user to download a file
    # (or upload it to any of the supported services). Set the content of
    # the button on the `text` parameter. The `url` of the content you want the user to save.
    # Define the `mimetype` of the content. Accepts a optional `options` parameter.
    #
    # #### Options
    #
    # - `:container` - Where to show the file picker dialog can be `modal`,
    # `window` or the id of an iframe on the page.
    # - `:services` - What services your users can upload to. Ex: `BOX, COMPUTER, FACEBOOK`.
    # - `:save_as_name` - A recommended file name. The user can override this.
    #
    # #### Examples
    #
    #     filepicker_save_button "Save", @user.filepicker_url, "image/jpg"
    #     # => <button data-fp-apikey="..." data-fp-mimetype="image/jpg" data-fp-url="https://www.filepicker.io/api/file/hFHUCB3iTxyMzseuWOgG" name="button" type="submit">save</button>
    #
    def filepicker_save_button(text, url, mimetype, options = {})
      export_widget(text, url, mimetype, options) do
        button_tag(text, options)
      end
    end

    # Creates a link allowing the user to download a file
    # (or upload it to any of the supported services). Set the content of
    # the link on the `text` parameter. The `url` of the content you want the user to save.
    # Define the `mimetype` of the content. Accepts a optional `options` parameter.
    #
    # #### Options
    #
    # - `:container` - Where to show the file picker dialog can be `modal`,
    # `window` or the id of an iframe on the page.
    # - `:services` - What services your users can upload to. Ex: `BOX, COMPUTER, FACEBOOK`.
    # - `:save_as_name` - A recommended file name. The user can override this.
    #
    # #### Examples
    #
    #     filepicker_save_link "Save", @user.filepicker_url, "image/jpg"
    #     # => <a data-fp-apikey="..." data-fp-mimetype="image/jpg" data-fp-url="https://www.filepicker.io/api/file/hFHUCB3iTxyMzseuWOgG" href="#" id="filepicker_export_widget_link">save</a>
    #
    def filepicker_save_link(text, url, mimetype, options = {})
      export_widget(text, url, mimetype, options) do
        options[:id] = options.fetch(:id, 'filepicker_export_widget_link')
        link_to text, '#', options
      end
    end

    # Creates a image tag of the `url`. Accepts the options to work on filepicker.io,
    # see the valid options on `filepicker_image_url` documentation. Accepts html options to the image tag,
    # see the [image_tag](http://api.rubyonrails.org/classes/ActionView/Helpers/AssetTagHelper.html#method-i-image_tag)
    # documentation for the valid options.
    #
    # #### Examples
    #
    #      filepicker_image_tag @user.filepicker_url, w: 160, h: 160, fit: 'clip'
    #      # => <img src="https://www.filepicker.io/api/file/hFHUCB3iTxyMzseuWOgG/convert?w=160&h=160&fit=clip" />
    #
    def filepicker_image_tag(url, image_options={}, image_tag_options={})
      image_tag(filepicker_image_url(url, image_options), image_tag_options)
    end

    # Creates the full path of the image to the specified `url` accepts optional `options`
    # hash for configuration.
    #
    # #### Options
    #
    # - `:w` - Resize the image to this width.
    #
    # - `:h` - Resize the image to this height.
    #
    # - `:fit` - Specifies how to resize the image. Possible values are:
    #     - `:clip` - Resizes the image to fit within the specified parameters without
    #             distorting, cropping, or changing the aspect ratio, this is the default.
    #     - `:crop` - Resizes the image to fit the specified parameters exactly by
    #             removing any parts of the image that don't fit within the boundaries
    #     - `:scales` - Resizes the image to fit the specified parameters exactly by
    #               scaling the image to the desired size
    # - `:align` - Determines how the image is aligned when resizing and using the "fit" parameter.
    #         Check API for details.
    #
    # - `:rotate` - Rotate the image. Default is no rotation. Possible values are:
    #     - `:exif` - will rotate the image automatically based on the exif data in the image.
    #     -  Other valid values are integers between 0 and 359, for degrees of rotation.
    #
    # - `:crop` - Crops the image to a specified rectangle. The input to this parameter
    #        should be 4 numbers for `x,y,width,height` - for example,
    #        `10, 20, 200, 250` would select the 200x250 pixel rectangle starting
    #        from 10 pixels from the left edge and 20 pixels from the top edge of the
    #        image.
    #
    # - `:crop_first` - Makes sure the image is cropped before any other
    #                   conversion parameters are executed.
    #                   The only value for this parameter is `true`.
    #
    # - `:format` - Specifies what format the image should be converted to, if any.
    #          Possible values are `jpg` and `png`. For `jpg` conversions, you
    #          can additionally specify a quality parameter.
    #
    # - `:quality` - For jpeg conversion, specifies the quality of the resultant image.
    #           Quality should be an integer between 1 and 100
    #
    # - `:watermark` - Adds the specified absolute url as a watermark on the image.
    #
    # - `:watersize` - This size of the watermark, as a percentage of the base
    #             image (not the original watermark).
    #
    # - `:waterposition` - Where to put the watermark relative to the base image.
    #                 Possible values for vertical position are `top`,`middle`,
    #                 `bottom` and `left`,`center`,`right`, for horizontal
    #                 position. The two can be combined by separating vertical
    #                 and horizontal with a comma. The default behavior
    #                 is bottom,right
    #
    # - `:cache` - Specifies if the image should be cached or not.
    #
    # #### Examples
    #
    #      filepicker_image_url @user.filepicker_url, w: 160, h: 160, fit: 'clip'
    #      # => https://www.filepicker.io/api/file/hFHUCB3iTxyMzseuWOgG/convert?w=160&h=160&fit=clip
    #
    def filepicker_image_url(url, options = {})
      FilepickerImageUrl.new(url, options).execute
    end

    class FilepickerImageUrl

      CONVERT_OPTIONS = [:w, :h, :fit, :align, :rotate, :crop, :format,
                         :quality, :watermark, :watersize, :waterposition,
                         :crop_first]
      VALID_OPTIONS   = CONVERT_OPTIONS + [:cache]

      def initialize(url, options = {})
        @url, @options = url, options
      end

      def execute
        base_url = url_with_path.split('?').first
        query_params = all_options.to_query

        [base_url, query_params.presence].compact.join('?')
      end

      private

        attr_reader :url, :options

        def valid_options
          options.select { |option| VALID_OPTIONS.include?(option) }
        end

        def convert_options
          options.select { |option| CONVERT_OPTIONS.include?(option) }
        end

        def all_options
          [original_url_options, valid_options, policy_config].inject(&:merge)
        end

        def original_url_options
          query_string = url_with_path.split('?')[1]

          if query_string
            Rack::Utils.parse_nested_query(query_string)
          else
            {}
          end
        end

        def cdn_host
          @cdn_host ||= ::Rails.application.config.filepicker_rails.cdn_host
        end

        def cdn_url
          if cdn_host
            uri = URI.parse(url)
            url.gsub("#{uri.scheme}://#{uri.host}", cdn_host)
          else
            url
          end
        end

        def policy_config
          Policy.apply
        end

        def url_with_path
          @url_with_path ||= if append_convert_on_url_path?
            "#{cdn_url}/convert"
          else
            cdn_url
          end
        end

        def append_convert_on_url_path?
          convert_options.any? && !cdn_url.match('/convert')
        end
    end
    private_constant :FilepickerImageUrl

    private

      def export_widget(text, url, mimetype, options, &block)
        options[:data] ||= {}
        container = options.delete(:container)
        services = options.delete(:services)
        save_as = options.delete(:save_as_name)

        options[:data]['fp-url'] = url
        options[:data]['fp-apikey'] = ::Rails.application.config.filepicker_rails.api_key
        options[:data]['fp-mimetype'] = mimetype
        options[:data]['fp-container'] = container if container
        options[:data]['fp-services'] = Array(services).join(",") if services
        options[:data]['fp-suggestedFilename'] = save_as if save_as
        block.call
      end
  end
end
