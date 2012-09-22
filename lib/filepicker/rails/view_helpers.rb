module Filepicker
  module Rails

    module ViewHelpers
      def filepicker_js_include_tag
        javascript_include_tag "//api.filepicker.io/v0/filepicker.js"
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


      def filepicker_image_tag(url, options={})
        image_tag(filepicker_image_url(url, options),
          width: options[:w],
          height: options[:h],

          alt: options[:alt])
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
        query_params = options.slice(:w,:h,:fit,:crop,:format,:quality,
          :watermark,:watersize,:waterposition).to_query
        [url, "/convert?", query_params].join
      end

    end
  end
end
