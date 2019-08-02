class Picker
  attr_reader :url

  def initialize
    @url = ::Rails.application.config.filestack_rails.url
  end

  def picker(client_name, api_key, options, callback, other_callbacks = nil)
    options_string = options[1..-2] # removed curly brackets help to generate pickerOptions in js

    <<~HTML
      (function(){
        #{client_name}.picker({ onUploadDone: data => #{callback}(data)#{other_callbacks}, #{options_string} }).open()
      })()
    HTML
  end

  def security(signature, policy)
    { security: { signature: signature, policy: policy } }.to_json
  end
end

class OutdatedPicker < Picker
  def picker(client_name, api_key, options, callback, other_callbacks = nil)
    <<~HTML
      (function(){
        #{client_name}.pick(#{options}).then(function(data){#{callback}(data)})
      })()
    HTML
  end

  def security(signature, policy)
    { signature: signature, policy: policy }.to_json
  end
end

module FilestackRails
  module FilestackJs
    def get_filestack_js
      if ::Rails.application.config.filestack_rails.version == FilestackRails::OUTDATED_VERSION
        OutdatedPicker.new
      else
        Picker.new
      end
    end
  end
end
