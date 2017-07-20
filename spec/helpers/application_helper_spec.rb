require 'rails_helper'

RSpec.describe FilestackRails::ApplicationHelper do
  include FilestackRails::ApplicationHelper
  include ActionView::Helpers
  describe '#filestack_js_include_tag' do
    it "be a script tag" do
      regex = %r{\A<script.*></script>\z}
      expect(filestack_js_include_tag).to match(regex)
    end

    it "include the correct type" do
      attribute = %{type="text/javascript"}
      expect(filestack_js_include_tag).to include(attribute)
    end

    it "has correct src attribute" do
      attribute = %{src="https://static.filestackapi.com/v3/filestack.js"}
      expect(filestack_js_include_tag).to include(attribute)
    end
  end

  describe "filestack_picker_element" do 
    it "has the right picker element" do
      html_string = filestack_picker_element "hello!", "console.log('hello!')"
      correct_string = '<button name="button" type="button" onclick="(function(){
        rich_client.pick({}).then(function(data){console.log(&#39;hello!&#39;)(data)})
      })()">hello!</button>'
      expect(html_string).to eq(correct_string)
    end
  end
end
