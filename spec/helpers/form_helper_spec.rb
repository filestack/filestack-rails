require 'spec_helper'
require 'timecop'

describe FilepickerRails::FormHelper do

  let!(:form) do
    ActionView::Helpers::FormBuilder.new(:user, nil, nil, {})
  end

  describe "#filepicker_field" do

    context "without options" do

      it "have correct output" do
        html = %{<input data-fp-apikey="123filepickerapikey" id="user_filepicker_url"}
        html << %{ name="user[filepicker_url]" type="filepicker" />}
        expect(form.filepicker_field(:filepicker_url)).to eq(html)
      end
    end

    context "with options" do

      it "have correct input with 'dragdrop'" do
        html = %{<input data-fp-apikey="123filepickerapikey" id="user_filepicker_url"}
        html << %{ name="user[filepicker_url]" type="filepicker-dragdrop" />}
        expect(form.filepicker_field(:filepicker_url, dragdrop: true)).to eq(html)
      end

      it "have correct input with 'button_text'" do
        html = %{<input data-fp-apikey="123filepickerapikey" data-fp-button-text="upload"}
        html << %{ id="user_filepicker_url" name="user[filepicker_url]" type="filepicker" />}
        expect(form.filepicker_field(:filepicker_url, button_text: "upload")).to eq(html)
      end

      it "have correct input with 'button_class'" do
        html = %{<input data-fp-apikey="123filepickerapikey" data-fp-button-class="button"}
        html << %{ id="user_filepicker_url" name="user[filepicker_url]" type="filepicker" />}
        expect(form.filepicker_field(:filepicker_url, button_class: "button")).to eq(html)
      end

      it "have correct input with 'mimetypes'" do
        html = %{<input data-fp-apikey="123filepickerapikey" data-fp-mimetypes="image/png,text/*"}
        html << %{ id="user_filepicker_url" name="user[filepicker_url]" type="filepicker" />}
        expect(form.filepicker_field(:filepicker_url, mimetypes: "image/png,text/*")).to eq(html)
      end

      it "have correct input with 'extensions'" do
        html = %{<input data-fp-apikey="123filepickerapikey" data-fp-extensions=".png,.jpg"}
        html << %{ id="user_filepicker_url" name="user[filepicker_url]" type="filepicker" />}
        expect(form.filepicker_field(:filepicker_url, extensions: ".png,.jpg")).to eq(html)
      end

      it "have correct input with 'container'" do
        html = %{<input data-fp-apikey="123filepickerapikey" data-fp-container="window"}
        html << %{ id="user_filepicker_url" name="user[filepicker_url]" type="filepicker" />}
        expect(form.filepicker_field(:filepicker_url, container: "window")).to eq(html)
      end

      it "have correct input with 'services'" do
        html = %{<input data-fp-apikey="123filepickerapikey"}
        html << %{ data-fp-services="BOX, COMPUTER, FACEBOOK"}
        html << %{ id="user_filepicker_url" name="user[filepicker_url]" type="filepicker" />}
        expect(form.filepicker_field(:filepicker_url, services: "BOX, COMPUTER, FACEBOOK")).to eq(html)
      end

      it "have correct input with 'drag_text'" do
        html = %{<input data-fp-apikey="123filepickerapikey" data-fp-drag-text="drag here"}
        html << %{ id="user_filepicker_url" name="user[filepicker_url]" type="filepicker" />}
        expect(form.filepicker_field(:filepicker_url, drag_text: "drag here")).to eq(html)
      end

      it "have correct input with 'drag_class'" do
        html = %{<input data-fp-apikey="123filepickerapikey" data-fp-drag-class="js-drag"}
        html << %{ id="user_filepicker_url" name="user[filepicker_url]" type="filepicker" />}
        expect(form.filepicker_field(:filepicker_url, drag_class: "js-drag")).to eq(html)
      end

      it "have correct input with 'store_path'" do
        html = %{<input data-fp-apikey="123filepickerapikey" data-fp-store-path="avatar"}
        html << %{ id="user_filepicker_url" name="user[filepicker_url]" type="filepicker" />}
        expect(form.filepicker_field(:filepicker_url, store_path: "avatar")).to eq(html)
      end

      it "have correct input with 'store_location'" do
        html = %{<input data-fp-apikey="123filepickerapikey" data-fp-store-location="S3"}
        html << %{ id="user_filepicker_url" name="user[filepicker_url]" type="filepicker" />}
        expect(form.filepicker_field(:filepicker_url, store_location: "S3")).to eq(html)
      end

      it "have correct input with 'store_access'" do
        html = %{<input data-fp-apikey="123filepickerapikey" data-fp-store-access="public"}
        html << %{ id="user_filepicker_url" name="user[filepicker_url]" type="filepicker" />}
        expect(form.filepicker_field(:filepicker_url, store_access: "public")).to eq(html)
      end

      it "have correct input with 'multiple'" do
        html = %{<input data-fp-apikey="123filepickerapikey" data-fp-multiple="true"}
        html << %{ id="user_filepicker_url" name="user[filepicker_url]" type="filepicker" />}
        expect(form.filepicker_field(:filepicker_url, multiple: true)).to eq(html)
      end

      it "have correct input with 'max_size'" do
        html = %{<input data-fp-apikey="123filepickerapikey" data-fp-maxSize="10"}
        html << %{ id="user_filepicker_url" name="user[filepicker_url]" type="filepicker" />}
        expect(form.filepicker_field(:filepicker_url, max_size: 10)).to eq(html)
      end

      it "have correct input with 'onchange'" do
        html = %{<input data-fp-apikey="123filepickerapikey" id="user_filepicker_url"}
        html << %{ name="user[filepicker_url]" onchange="track()" type="filepicker" />}
        expect(form.filepicker_field(:filepicker_url, onchange: "track()")).to eq(html)
      end

      it "have correct input with 'class'" do
        html = %{<input class="js-field" data-fp-apikey="123filepickerapikey"}
        html << %{ id="user_filepicker_url" name="user[filepicker_url]" type="filepicker" />}
        expect(form.filepicker_field(:filepicker_url, class: "js-field")).to eq(html)
      end

      it "have correct input with 'value'" do
        html = %{<input data-fp-apikey="123filepickerapikey" id="user_filepicker_url"}
        html << %{ name="user[filepicker_url]" type="filepicker" value="avatar" />}
        expect(form.filepicker_field(:filepicker_url, value: "avatar")).to eq(html)
      end

      describe "policy" do

        before do
          Timecop.freeze(Time.zone.parse("2012-09-19 12:59:27"))
          Rails.application.config.filepicker_rails.secret_key = 'filepicker123secretkey'
        end

        after do
          Rails.application.config.filepicker_rails.secret_key = nil
          Timecop.return
        end

        it "have correct input with policy" do
          html = %{<input data-fp-apikey="123filepickerapikey"}
          html << %{ data-fp-policy="eyJleHBpcnkiOjEzNDgwNjAxNjcsImNhbGwiOlsicGljayIsInN0b3JlIl19"}
          html << %{ data-fp-signature="7bbfb03a94967056d4c98140a3ce188ec7a5b575d2cd86fe5528d7fafb3387c3"}
          html << %{ id="user_filepicker_url" name="user[filepicker_url]" type="filepicker" />}
          expect(form.filepicker_field(:filepicker_url)).to eq(html)
        end
      end
    end
  end
end
