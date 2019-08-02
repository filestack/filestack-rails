require 'rails_helper'

RSpec.describe FilestackRails::Transform do
  let!(:configuration) { ::Rails.application.config.filestack_rails }

  before { configuration.api_key = 'API_KEY' }

  let!(:transform) do
    get_transform(configuration.api_key)
  end

  describe "#transform_object without security" do
    it "considers av_convert bad transform" do
      expect{ transform.url }.to raise_error(RuntimeError)
    end
  end

  describe "#transform_object with security" do
    before do
      configuration.app_secret = 'APP_SECRET'
      configuration.security = { call: %w[read store pick convert remove], expiry: 60 }
    end

    it "considers av_convert bad transform" do
      expect{ transform.av_convert(width: 100) }.to raise_error(RuntimeError)
    end

    it "considers url bad transform" do
      expect{ transform.url }.to raise_error(RuntimeError)
    end

    it "considers store bad transform" do
      expect{ transform.store }.to raise_error(RuntimeError)
    end

    it "considers debug bad transform" do
      expect{ transform.debug }.to raise_error(RuntimeError)
    end
  end
end
