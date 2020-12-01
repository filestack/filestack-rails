require 'rails_helper'

RSpec.describe FilestackRails::ApplicationHelper do
  include FilestackRails::ApplicationHelper
  include ActionView::Helpers
  describe '#filestack_js_include_tag' do
    it "is a script tag" do
      regex = %r{\A<script.*></script>\z}
      expect(filestack_js_include_tag).to match(regex)
    end

    it "js_initn is a script tag" do
      init_tag = filestack_js_init_tag
      expect(init_tag).to include('<script')
      expect(init_tag).to include('</script>')
      expect(init_tag).to include('filestack.init')
    end

    it "includes the correct type" do
      attribute = %{type="text/javascript"}
      expect(filestack_js_include_tag).to include(attribute)
    end

    it "has correct src attribute" do
      attribute = %{src="https://static.filestackapi.com/filestack-js/3.x.x/filestack.min.js"}
      expect(filestack_js_include_tag).to include(attribute)
    end
  end

  describe "#filestack_picker_element" do
    it "has the right picker element" do
      html_string = filestack_picker_element("Pick!", "console.log('Pick!')").gsub(/\s+/, ' ')
      correct_string = '<button name="button" type="button" onclick="(function(){
                          filestack_client.picker({ onUploadDone: data =&gt; console.log(&#39;Pick!&#39;)(data), }).open()
                        })() ">Pick!</button>'.gsub(/\s+/, ' ')

      expect(html_string).to eq(correct_string)
    end
  end

  describe "#filestack_image" do
    it "returns the image tag with transformation" do
      image = filestack_image 'www.example.com', transform: filestack_transform.resize(width: 100, height: 100)
      correct = '<img src="https://cdn.filestackcontent.com/API_KEY/resize=width:100,height:100/www.example.com" />'
      expect(image).to eq(correct)
    end

    it "returns the image tag with attributes" do
      image = filestack_image 'https://cdn.filestackcontent.com/7Djkxw9TPyEWdjxILnUQ', size: '16x10'
      correct = '<img src="https://cdn.filestackcontent.com/7Djkxw9TPyEWdjxILnUQ" width="16" height="10" />'
      expect(image).to eq(correct)
    end
  end

  describe "#get_policy_and_signature" do
    it "returns empty data" do
      expect(get_policy_and_signature).to eq([nil, nil])
    end
  end

  describe "#filestack_image_url" do
    it "returns the image url with transformation" do
      image_url = filestack_image_url 'www.example.com', filestack_transform.resize(width: 100, height: 100)
      correct = "https://cdn.filestackcontent.com/API_KEY/resize=width:100,height:100/www.example.com"
      expect(image_url).to eq(correct)
    end
  end

  describe "#get_policy_and_signature_string" do
    let(:signature) { "signature123" }
    let(:policy) { "policy321" }

    it "returns correct data" do
      allow_any_instance_of(FilestackRails::ApplicationHelper).to receive(:get_policy_and_signature)
        .and_return([:policy, :signature])

      expect(get_policy_and_signature_string).to eq(
        {"security":{"signature": :signature, "policy": :policy}}.to_json
      )
    end

    it "returns empty data" do
      expect(get_policy_and_signature_string).to eq("''")
    end
  end

  describe "#security" do
    it "returns signature and policy" do
      allow(Rails.application.config.filestack_rails).to receive(:security)
        .and_return({call: %w[read store pick stat write], expiry: 60})
      allow(Rails.application.config.filestack_rails).to receive(:app_secret)
        .and_return('app_secret123')

      expect(security.policy).to be
      expect(security.signature).to be
    end

    it "does not return signature and policy" do
      allow(::Rails.application.config.filestack_rails).to receive(:security).and_return(nil)
      expect(security).to be(nil)
    end
  end

  describe "#build_callbacks_js" do
    expected_values = {
      { onClose: 'callbackOnClose' } => ', onClose: () => callbackOnClose()',
      { onOpen: 'callbackOnOpen' } => ', onOpen: data => callbackOnOpen(data)',
      { onFileUploadFinished: 'callbackOnFileUploadFinished' } => ', onFileUploadFinished: data => callbackOnFileUploadFinished(data)',
      { onFileSelected: 'callbackOnFileSelected' } => ', onFileSelected: data => callbackOnFileSelected(data)',
      { onUploadStarted: 'callbackOnUploadStarted' } => ', onUploadStarted: data => callbackOnUploadStarted(data)'
    }
    expected_values.each do |val, expected|
      it "returns correct string for #{val}" do
        result = build_callbacks_js(val)
        expect(result).to eq(expected)
      end
    end
  end
end
