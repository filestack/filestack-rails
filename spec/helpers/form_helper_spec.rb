require 'spec_helper'

describe FilepickerRails::FormHelper do

  describe "#filepicker_js_include_tag" do

    context "without options" do

      it "have correct output" do
        html = %{<input data-fp-apikey="123filepickerapikey" type="filepicker" />}
        expect(filepicker_field(:filepicker_url)).to eq(html)
      end
    end

    context "with options" do

      it "have correct input with 'dragdrop'" do
        html = %{<input data-fp-apikey="123filepickerapikey" type="filepicker-dragdrop" />}
        expect(filepicker_field(:filepicker_url, dragdrop: true)).to eq(html)
      end

      it "have correct input with 'button_text'" do
        html = %{<input data-fp-apikey="123filepickerapikey" data-fp-button-text="upload" type="filepicker" />}
        expect(filepicker_field(:filepicker_url, button_text: "upload")).to eq(html)
      end

      it "have correct input with 'button_class'" do
        html = %{<input data-fp-apikey="123filepickerapikey" data-fp-button-class="button" type="filepicker" />}
        expect(filepicker_field(:filepicker_url, button_class: "button")).to eq(html)
      end

      it "have correct input with 'mimetypes'" do
        html = %{<input data-fp-apikey="123filepickerapikey" data-fp-mimetypes="image/png,text/*" type="filepicker" />}
        expect(filepicker_field(:filepicker_url, mimetypes: "image/png,text/*")).to eq(html)
      end

      it "have correct input with 'extensions'" do
        html = %{<input data-fp-apikey="123filepickerapikey" data-fp-extensions=".png,.jpg" type="filepicker" />}
        expect(filepicker_field(:filepicker_url, extensions: ".png,.jpg")).to eq(html)
      end

      it "have correct input with 'container'" do
        html = %{<input data-fp-apikey="123filepickerapikey" data-fp-container="window" type="filepicker" />}
        expect(filepicker_field(:filepicker_url, container: "window")).to eq(html)
      end

      it "have correct input with 'services'" do
        html = %{<input data-fp-apikey="123filepickerapikey"}
        html << %{ data-fp-services="BOX, COMPUTER, FACEBOOK" type="filepicker" />}
        expect(filepicker_field(:filepicker_url, services: "BOX, COMPUTER, FACEBOOK")).to eq(html)
      end

      it "have correct input with 'drag_text'" do
        html = %{<input data-fp-apikey="123filepickerapikey" data-fp-drag-text="drag here" type="filepicker" />}
        expect(filepicker_field(:filepicker_url, drag_text: "drag here")).to eq(html)
      end

      it "have correct input with 'drag_class'" do
        html = %{<input data-fp-apikey="123filepickerapikey" data-fp-drag-class="js-drag" type="filepicker" />}
        expect(filepicker_field(:filepicker_url, drag_class: "js-drag")).to eq(html)
      end

      it "have correct input with 'store_path'" do
        html = %{<input data-fp-apikey="123filepickerapikey" data-fp-store-path="avatar" type="filepicker" />}
        expect(filepicker_field(:filepicker_url, store_path: "avatar")).to eq(html)
      end

      it "have correct input with 'store_location'" do
        html = %{<input data-fp-apikey="123filepickerapikey" data-fp-store-location="S3" type="filepicker" />}
        expect(filepicker_field(:filepicker_url, store_location: "S3")).to eq(html)
      end

      it "have correct input with 'multiple'" do
        html = %{<input data-fp-apikey="123filepickerapikey" data-fp-multiple="true" type="filepicker" />}
        expect(filepicker_field(:filepicker_url, multiple: true)).to eq(html)
      end

      it "have correct input with 'onchange'" do
        html = %{<input data-fp-apikey="123filepickerapikey" onchange="track()" type="filepicker" />}
        expect(filepicker_field(:filepicker_url, onchange: "track()")).to eq(html)
      end

      it "have correct input with 'class'" do
        html = %{<input class="js-field" data-fp-apikey="123filepickerapikey" type="filepicker" />}
        expect(filepicker_field(:filepicker_url, class: "js-field")).to eq(html)
      end

      it "have correct input with 'value'" do
        html = %{<input data-fp-apikey="123filepickerapikey" type="filepicker" value="avatar" />}
        expect(filepicker_field(:filepicker_url, value: "avatar")).to eq(html)
      end
    end
  end
end
