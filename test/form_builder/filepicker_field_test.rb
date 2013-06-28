require 'test_helper'

class FilepickerFieldTest < ActionView::TestCase
  setup { @user = User.new }

  test "builder should render name attribute" do
    with_concat_form_for(@user) do |f|
      f.filepicker_field :file_url
    end

    assert_select "form input" do
      assert_select "[name=?]", "user[file_url]"
    end
  end
end