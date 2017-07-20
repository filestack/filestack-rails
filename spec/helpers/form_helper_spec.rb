require 'rails_helper'

RSpec.describe FilestackRails::ApplicationHelper do
  include FilestackRails::ApplicationHelper
  include FilestackRails::FormHelper
  include ActionView::Helpers
  describe '#filestack_field' do
    it "provides the correct form_tag" do
      output = filestack_field :picture, "some content"
      expect(output).to include("<button")
      expect(output).to include("</button>")     
    end
  end
end
