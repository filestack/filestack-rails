require 'spec_helper'

describe FilepickerRails::ApplicationHelper do

  describe "#filepicker_js_include_tag" do

    it "have correct output" do
      filepicker_js_include_tag.should eq(%{<script src="//api.filepicker.io/v1/filepicker.js"></script>})
    end
  end
end
