require 'rails_helper'
RSpec.describe FilestackRails::Configuration do

  let!(:configuration) do
    FilestackRails::Configuration.new
  end

  describe '#api_key=' do
    it 'responds to api_key=' do
      expect(configuration).to respond_to(:api_key=)
    end
  end

  describe '#api_key' do
    it 'have defined value' do
      configuration.api_key = "my api key"
      expect(configuration.api_key).to eq("my api key")
    end

    it 'raise error when @api_key is not defined' do
      expect do
        configuration.api_key
      end.to raise_error(RuntimeError, 'Set config.filestack_rails.api_key')
    end
  end

  describe '#security' do
    it 'has no security' do
      expect(configuration.security).to be(nil)
    end

    it 'has security' do
      configuration.app_secret = 'somesecret'
      configuration.security = {}
      expect(configuration.security).to eq({})
    end

    it 'has not defined @app_secret' do
      expect do
        configuration.app_secret = nil
        configuration.security = {}
      end.to raise_error(RuntimeError, 'You must have secret key to use security')
    end
  end

  describe '#cname' do
    it 'has no cname' do
      expect(configuration.cname).to be(nil)
    end

    it 'has cname' do
      cname = 'fs.mycname.com'
      configuration.cname = cname
      expect(configuration.cname).to eq cname
    end
  end

  describe '#version' do
    it 'has no version' do
      expect(configuration.version).to eq('3.x.x')
    end

    it 'has version' do
      version = '3.x.x'
      configuration.version = version
      expect(configuration.version).to eq version
    end
  end

  describe '#expiry' do
    it 'has no expiry' do
      now = Time.parse('2019-01-23 12:47:25 +0100')
      zone = double('timezone')
      allow(zone).to receive(:now).and_return(now)
      allow(Time).to receive(:zone).and_return(zone)

      expect(configuration.expiry).to eq(1548244645)
    end

    it 'has expiry' do
      expiry = '1548244645'
      configuration.expiry = expiry
      expect(configuration.expiry).to eq expiry
    end
  end

  describe '#app_secret' do
    it 'has defined value' do
      configuration.app_secret = "my app secret"
      expect(configuration.app_secret).to eq("my app secret")
    end

    it 'has no @app_secret' do
      expect(configuration.app_secret).to eq(nil)
    end
  end
end
