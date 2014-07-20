require 'rails_helper'

RSpec.describe FilepickerRails::Configuration do

  let!(:configuration) do
    FilepickerRails::Configuration.new
  end

  describe "#api_key=" do

    it "respond to api_key=" do
      expect(configuration).to respond_to(:api_key=)
    end
  end

  describe "#secret_key=" do

    it "respond to secret_key=" do
      expect(configuration).to respond_to(:secret_key=)
    end
  end

  describe "#expiry=" do

    it "respond to expiry=" do
      expect(configuration).to respond_to(:expiry=)
    end

    it 'raises error if not receive a callable' do
      expect do
        configuration.expiry = 12
      end.to raise_error(ArgumentError, 'Must be a callable')
    end
  end

  describe "#api_key" do

    it "have defined value" do
      configuration.api_key = "my api key"
      expect(configuration.api_key).to eq("my api key")
    end

    it "raise error when @api_key is not defined" do
      expect do
        configuration.api_key
      end.to raise_error(RuntimeError, "Set config.filepicker_rails.api_key")
    end
  end

  describe "#secret_key" do

    it "have defined value" do
      configuration.secret_key = "my secret key"
      expect(configuration.secret_key).to eq("my secret key")
    end
  end

  describe "#expiry" do

    it "have defined value" do
      configuration.expiry = -> { 450 }
      expect(configuration.expiry.call).to eq(450)
    end

    it "have a default value" do
      Timecop.freeze(Time.zone.parse("2012-09-19 12:59:27")) do
        expect(configuration.expiry.call).to eq(1348060167)
      end
    end
  end

  describe "#cdn_host" do

    it "have defined value" do
      configuration.cdn_host = "https://cdn.example.com"
      expect(configuration.cdn_host).to eq("https://cdn.example.com")
    end

    it "have a default value" do
      expect(configuration.cdn_host).to eq(nil)
    end
  end
end

