module FilepickerRails
  module ApplicationHelper

    def filepicker_js_include_tag
      javascript_include_tag "//api.filepicker.io/v1/filepicker.js"
    end

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

    # Allows options to be passed to filepicker_image_url and then falls back to normal Rails options
    # for image_tag
    # If specifying html width, height, pass it down to filepicker for optimization
    def filepicker_image_tag(url, image_options={}, image_tag_options={})
      image_tag(filepicker_image_url(url, image_options), image_tag_options)
    end

    # w - Resize the image to this width.
    #
    # h - Resize the image to this height.
    #
    # fit - Specifies how to resize the image. Possible values are:
    #       clip: Resizes the image to fit within the specified parameters without
    #             distorting, cropping, or changing the aspect ratio
    #       crop: Resizes the image to fit the specified parameters exactly by
    #             removing any parts of the image that don't fit within the boundaries
    #       scales: Resizes the image to fit the specified parameters exactly by
    #               scaling the image to the desired size
    #       Defaults to "clip".
    # align - Determines how the image is aligned when resizing and using the "fit" parameter.
    #         Check API for details.
    #
    # rotate - Rotate the image. Default is no rotation.
    #          rotate="exif" will rotate the image automatically based on the exif data in the image.
    #          Other valid values are integers between 0 and 359, for degrees of rotation.
    #
    # cache - Specifies if the image should be cached or not.
    #
    # crop - Crops the image to a specified rectangle. The input to this parameter
    #        should be 4 numbers for 'x,y,width,height' - for example,
    #        'crop=10,20,200,250' would select the 200x250 pixel rectangle starting
    #        from 10 pixels from the left edge and 20 pixels from the top edge of the
    #        image.
    #
    # format - Specifies what format the image should be converted to, if any.
    #          Possible values are "jpg" and "png". For "jpg" conversions, you
    #          can additionally specify a quality parameter.
    #
    # quality - For jpeg conversion, specifies the quality of the resultant image.
    #           Quality should be an integer between 1 and 100
    #
    # watermark - Adds the specified absolute url as a watermark on the image.
    #
    # watersize - This size of the watermark, as a percentage of the base
    #             image (not the original watermark).
    #
    # waterposition - Where to put the watermark relative to the base image.
    #                 Possible values for vertical position are "top","middle",
    #                 "bottom" and "left","center","right", for horizontal
    #                 position. The two can be combined by separating vertical
    #                 and horizontal with a comma. The default behavior
    #                 is bottom,right
    def filepicker_image_url(url, options = {})
      FilepickerImageUrl.new(url, options).execute
    end

    class FilepickerImageUrl

      VALID_OPTIONS = [:w, :h, :fit, :align, :rotate, :cache, :crop, :format,
                       :quality, :watermark, :watersize, :waterposition]

      def initialize(url, options = {})
        @url, @options = url, options
        remove_invalid_options
        apply_cdn_to_url
        apply_policy
      end

      def execute
        query_params = options.to_query
        if has_convert_options?
          [url, '/convert?', query_params]
        elsif has_policy?
          [url,'?', query_params]
        else
          [url, query_params]
        end.join
      end

      private

        attr_reader :url, :options

        def remove_invalid_options
          options.delete_if{ |o| !VALID_OPTIONS.include?(o) }
        end

        def cdn_host
          ::Rails.application.config.filepicker_rails.cdn_host
        end

        def has_policy?
          policy_config.any?
        end

        def has_convert_options?
          options.keys.any?{ |k| VALID_OPTIONS.include?(k) }
        end

        def apply_cdn_to_url
          if cdn_host
            uri = URI.parse(url)
            @url = url.gsub("#{uri.scheme}://#{uri.host}", cdn_host)
          end
        end

        def apply_policy
          options.merge!(policy_config)
        end

        def policy_config
          return {} unless ::Rails.application.config.filepicker_rails.secret_key.present?
          grant = Policy.new
          grant.call = [:pick, :store]

          {
            'policy' => grant.policy,
            'signature' => grant.signature
          }
        end
    end
  end
end
