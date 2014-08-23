module FilepickerRails
  module ApplicationHelper

    # Creates a javascript tag to the filepicker JavaScript.
    #
    # #### Examples
    #
    #     filepicker_js_include_tag
    #     # => <script src="//api.filepicker.io/v1/filepicker.js"></script>
    def filepicker_js_include_tag
      javascript_include_tag "//api.filepicker.io/v1/filepicker.js"
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
      options[:data] ||= {}
      container = options.delete(:container)
      services = options.delete(:services)
      save_as = options.delete(:save_as_name)

      options[:data]['fp-url'] = url
      options[:data]['fp-apikey'] = ::Rails.application.config.filepicker_rails.api_key
      options[:data]['fp-mimetype'] = mimetype
      options[:data]['fp-option-container'] = container if container
      options[:data]['fp-option-services'] = Array(services).join(",") if services
      options[:data]['fp-option-defaultSaveasName'] = save_as if save_as
      button_tag(text, options)
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
                         :quality, :watermark, :watersize, :waterposition]
      VALID_OPTIONS   = CONVERT_OPTIONS + [:cache]

      def initialize(url, options = {})
        @url, @options = url, options
      end

      def execute
        url_with_path = if convert_options.any?
          "#{cdn_url}/convert"
        else
          cdn_url
        end

        query_params = all_options.merge(policy_config).to_query

        [url_with_path, query_params.presence].compact.join('?')
      end

      private

        attr_reader :url, :options

        def all_options
          options.select { |option| VALID_OPTIONS.include?(option) }
        end

        def convert_options
          options.select { |option| CONVERT_OPTIONS.include?(option) }
        end

        def cdn_host
          ::Rails.application.config.filepicker_rails.cdn_host
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
    end
    private_constant :FilepickerImageUrl
  end
end
