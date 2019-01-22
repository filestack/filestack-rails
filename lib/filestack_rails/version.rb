class FilestackVersion
  def initialize
    @version = ::Rails.application.config.filestack_rails.version
  end

  def determine_filestack_js(strategies)
    begin
      strategies[@version.to_sym].call
    rescue
      raise 'Set correct version in config.filestack_rails.version'
    end
  end
end

module FilestackRails
  VERSION = '3.2.2'

  module Version
    def load_filestack_js(strategies)
        FilestackVersion.new.determine_filestack_js(strategies)
    end
  end
end
