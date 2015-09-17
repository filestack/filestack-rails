# Creates the full path of the image to the specified `url` accepts optional
# `options` hash for configuration.
#
# #### Constructor
#
# @param [String] url                       Base filepicker url
# @param [Hash] options
# @option options [Fixnum] :w               Resize the image to this width.
# @option options [Fixnum] :h               Resize the image to this height.
# @option options [Symbol] :fit             Specifies how to resize the image.
#         Possible values are:
#
#     - `:clip` - Resizes the image to fit within the specified parameters without
#             distorting, cropping, or changing the aspect ratio, this is the default.
#     - `:crop` - Resizes the image to fit the specified parameters exactly by
#             removing any parts of the image that don't fit within the boundaries
#     - `:scales` - Resizes the image to fit the specified parameters exactly by
#               scaling the image to the desired size
#
# @option options [Symbol] :align           Determines how the image is aligned
#       when resizing and using the "fit" parameter. Check API for details.
#
# @option options [Symbol] :rotate          Rotate the image. Default is no
#       rotation. Possible values are:
#
#     - `:exif` - will rotate the image automatically based on the exif data in the image.
#     -  Other valid values are integers between 0 and 359, for degrees of rotation.
#
# @option options [String] :crop            Crops the image to a specified
#       rectangle. The input to this parameter should be 4 numbers for
#       `x,y,width,height` - for example, `10, 20, 200, 250` would select the
#       200x250 pixel rectangle starting from 10 pixels from the left edge and
#       20 pixels from the top edge of the image.
#
# @option options [String] :crop_first      Makes sure the image is cropped
#       before any other conversion parameters are executed. The only value for
#       this parameter is `true`.
#
# @option options [String] :format          Specifies what format the image
#       should be converted to, if any. Possible values are `jpg` and `png`.
#       For `jpg` conversions, you can additionally specify a quality parameter.
#
# @option options [String] :quality         For jpeg conversion, specifies the
#       quality of the resultant image. Quality should be an integer between 1
#       and 100
#
# @option options [String] :watermark       Adds the specified absolute url as
#       a watermark on the image.
#
# @option options [String] :watersize       This size of the watermark, as a
#       percentage of the base image (not the original watermark).
#
# @option options [String] :waterposition   Where to put the watermark relative
#       to the base image. Possible values for vertical position are `top`,
#       `middle`, `bottom` and `left`, `center`, `right`, for horizontal
#       position. The two can be combined by separating vertical and horizontal
#       with a comma. The default behavior is bottom,right
#
# @option options [String] :cache           Specifies if the image should be
#       cached or not.
#
# #### Examples
#
#     FilepickerRails::FilepickerImageUrl.new("https://www.filepicker.io/api/file/hFHUCB3iTxyMzseuWOgG", w: 160, h: 160).execute
#     # => https://www.filepicker.io/api/file/hFHUCB3iTxyMzseuWOgG/convert?w=160&h=160&fit=clip
#
module FilepickerRails
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
end
