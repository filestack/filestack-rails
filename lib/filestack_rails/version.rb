class FilestackVersion
  def initialize(results)
    @version = ::Rails.application.config.filestack_rails.version
    @results = results
  end

  def determine_filestack_js_result
    begin
      @results[@version.to_sym].call
    rescue
      raise 'Set correct version in config.filestack_rails.version'
    end
  end
end

module FilestackRails
  VERSION = '4.0.0'

  module Version
    def get_filestack_js_result(results)
        FilestackVersion.new(results).determine_filestack_js_result
    end
  end
end
