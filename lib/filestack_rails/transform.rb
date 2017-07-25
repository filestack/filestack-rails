require 'filestack'

class FilestackTransform
    def initialize(apikey)
        security = ::Rails.application.config.filestack_rails.security
        if !security.nil?
            @transform = Transform.new(apikey: apikey, security: security)
        else
            @transform = Transform.new(apikey: apikey)
        end
    end

    def method_missing(method_name, **args)
        if defined? @transform.send(method_name)
            raise "Invalid transformation for filestack_image" unless scrub_bad_transforms(method_name)
            @transform = @transform.send(method_name, **args)
            self
        else
            super
        end
    end

    def add_external_url(url)
        @transform.instance_variable_set(:@external_url, url)
    end

    def fs_url
        @transform.url
    end
end 

module FilestackRails
    module Transform

        def get_transform(apikey)
            FilestackTransform.new(apikey)
        end

    end
end

private 

def scrub_bad_transforms(method_name)
    !['av_convert', 'debug', 'store', 'url'].include? method_name.to_s
end