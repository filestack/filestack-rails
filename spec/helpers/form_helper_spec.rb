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

    it 'provides the default input id' do
      @object = Object.new
      output = filestack_field :picture, 'some content'
      expect(output).to include('object_picture')
    end

    context 'when options input_id is set' do
      let(:options) { {input_id: 'my_custom_id'} }

      it 'provides the correct input_id' do
        output = filestack_field :picture, 'some content', options
        expect(output).to include('my_custom_id')
      end
    end
  end
end
