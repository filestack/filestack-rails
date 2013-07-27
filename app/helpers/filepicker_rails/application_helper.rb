module FilepickerRails
  module ApplicationHelper

    def filepicker_js_include_tag
      javascript_include_tag "//api.filepicker.io/v1/filepicker.js"
    end
  end
end
