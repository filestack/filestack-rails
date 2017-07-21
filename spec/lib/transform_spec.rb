require 'rails_helper'

RSpec.describe FilestackRails::Transform do
    
    let!(:transform) do
        get_transform('someapikey')
    end

    describe "#transform_object" do
        it "considers av_convert bad transform" do
            expect{transform.av_convert(width:100)}.to raise_error(RuntimeError)
        end

        it "considers url bad transform" do
            expect{transform.url}.to raise_error(RuntimeError)
        end


        it "considers store bad transform" do
            expect{transform.store}.to raise_error(RuntimeError)
        end

        it "considers debug bad transform" do
            expect{transform.debug}.to raise_error(RuntimeError)
        end
    end

end