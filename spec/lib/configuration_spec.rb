require 'spec_helper'

describe FilepickerRails::Configuration do

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

  describe "#default_expiry=" do

    it "respond to default_expiry=" do
      expect(configuration).to respond_to(:default_expiry=)
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

  describe "#default_expiry" do

    it "have defined value" do
      configuration.default_expiry = 450
      expect(configuration.default_expiry).to eq(450)
    end

    it "have a default value" do
      expect(configuration.default_expiry).to eq(600)
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

