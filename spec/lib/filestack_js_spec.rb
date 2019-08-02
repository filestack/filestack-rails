require 'rails_helper'

RSpec.describe FilestackRails::FilestackJs do
  describe '#get_filestack_js' do
    let!(:configuration) { ::Rails.application.config.filestack_rails }
    let(:signature) { 'SIGNATURE' }
    let(:policy) { 'POLICY' }

    context 'when version is outdated' do
      before do
        configuration.version = '0.11.5'
      end

      it 'returns filestack-js url' do
        expect(get_filestack_js.url).to eq('https://static.filestackapi.com/v3/filestack.js')
      end

      it 'returns picker' do
        picker = get_filestack_js.picker('filestack', 'apikey', 'options', 'callback', nil)
        expect(picker).to eq(
          <<~HTML
           (function(){
             filestack.pick(options).then(function(data){callback(data)})
           })()
         HTML
        )
      end

      it 'returns security' do
        security = get_filestack_js.security(signature, policy)
        expect(security).to eq({ signature: signature, policy: policy }.to_json)
      end
    end

    context 'when version exists' do
      before do
        configuration.version = '3.x.x'
      end

      it 'returns filestack-js url' do
        expect(get_filestack_js.url).to eq(
          "https://static.filestackapi.com/filestack-js/#{configuration.version}/filestack.min.js"
        )
      end

      it 'returns picker' do
        picker = get_filestack_js.picker('filestack', 'apikey', '{options}', 'callback', 'other_callbacks')
        expect(picker).to eq(
          <<~HTML
            (function(){
              filestack.picker({ onUploadDone: data => callback(data)other_callbacks, options }).open()
            })()
          HTML
        )
      end

      it 'returns security' do
        security = get_filestack_js.security(signature, policy)
        expect(security).to eq({ security: { signature: signature, policy: policy } }.to_json)
      end
    end
  end
end
