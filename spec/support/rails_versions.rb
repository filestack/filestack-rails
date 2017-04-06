module RailsVersions
  def rails_version
    Gem::Version.new(Rails::VERSION::STRING)
  end
  module_function :rails_version

  def rails_4_1_x_up?
    Gem::Requirement.new('>= 4.1').satisfied_by?(rails_version)
  end
  module_function :rails_4_1_x_up?

end

RSpec.configure do |config|
  config.include(RailsVersions)
  config.extend(RailsVersions)
end
