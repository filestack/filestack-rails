require 'rails_helper'

RSpec.describe FilepickerRails::FormHelper do

  let!(:form) do
    if rails_4_1_x?
      ActionView::Helpers::FormBuilder.new(:user, nil, nil, {})
    else
      ActionView::Helpers::FormBuilder.new(:user, nil, nil, {}, nil)
    end
  end

  describe "#filepicker_field" do

    it_behaves_like "a filepicker input tag" do
      let(:args) { [:filepicker_url] }
      let(:filepicker_input_tag) { form.filepicker_field(*args) }
    end
  end
end
