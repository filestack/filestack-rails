if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.4.0')
  appraise '3.2' do
    gem 'rails', '~> 3.2.22'
    gem 'test-unit', '~> 3.0'
    gem 'rack-cache', '< 1.3'
  end

  appraise '4.0' do
    gem 'rails', '~> 4.0.13'
    gem 'test-unit', '~> 3.0'
  end

  appraise '4.1' do
    gem 'rails', '~> 4.1.13'
  end

  appraise '4.2' do
    gem 'rails', '~> 4.2.4'
  end
else
  appraise '5.0' do
    gem 'rails', '~> 5.0.2'
  end
end
