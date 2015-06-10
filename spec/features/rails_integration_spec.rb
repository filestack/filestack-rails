require 'rails_helper'

RSpec.feature 'Rails integration' do

  background do
    visit '/'
  end

  scenario 'adding the the javascript helper' do
    script_tag = 'script[src="//api.filepicker.io/v2/filepicker.js"]'
    expect(page).to have_css(script_tag, visible: false)
  end

  scenario 'using the form helper' do
    input_tag = 'input[data-fp-apikey="123filepickerapikey"]' \
                '[id="user_filepicker_url"][name="user[filepicker_url]"]' \
                '[type="filepicker"]'
    expect(page).to have_css(input_tag)
  end
end
