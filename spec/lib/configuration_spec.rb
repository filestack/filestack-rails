require 'rails_helper'
RSpec.describe FilestackRails::Configuration do

  let!(:configuration) do
    FilestackRails::Configuration.new
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
end
