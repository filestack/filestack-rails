require 'rails_helper'

RSpec.describe FilepickerRails::FormHelper do

  let!(:form) do
    if rails_4_1_x_up?
      ActionView::Helpers::FormBuilder.new(:user, nil, nil, {})
    else
      ActionView::Helpers::FormBuilder.new(:user, nil, nil, {}, nil)
    end
  end

  describe "#filepicker_field" do

    include_examples "a filepicker input tag" do
      let(:args) do
        [:filepicker_url]
      end

      let(:filepicker_input_tag) do
        form.filepicker_field(*args)
      end
    end
  end
end
