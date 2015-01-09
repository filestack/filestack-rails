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

    context "without options" do

      it "be a input tag" do
        regex = %r{\A<input.*/>\z}
        expect(form.filepicker_field(:filepicker_url)).to match(regex)
      end

      it "has correct data-fp-apikey attribute" do
        attribute = %{data-fp-apikey="123filepickerapikey"}
        expect(form.filepicker_field(:filepicker_url)).to include(attribute)
      end

      it "has correct id attribute" do
        attribute = %{id="user_filepicker_url"}
        expect(form.filepicker_field(:filepicker_url)).to include(attribute)
      end

      it "has correct name attribute" do
        attribute = %{name="user[filepicker_url]"}
        expect(form.filepicker_field(:filepicker_url)).to include(attribute)
      end

      it "has correct type attribute" do
        attribute = %{type="filepicker"}
        expect(form.filepicker_field(:filepicker_url)).to include(attribute)
      end
    end

    context "with options" do

      it "have correct input with 'dragdrop'" do
        attribute = %{type="filepicker-dragdrop"}
        expect(form.filepicker_field(:filepicker_url, dragdrop: true)).to include(attribute)
      end

      it "have correct input with 'button_text'" do
        attribute = %{data-fp-button-text="upload"}
        expect(form.filepicker_field(:filepicker_url, button_text: "upload")).to include(attribute)
      end

      it "have correct input with 'button_class'" do
        attribute = %{data-fp-button-class="button"}
        expect(form.filepicker_field(:filepicker_url, button_class: "button")).to include(attribute)
      end

      it "have correct input with 'mimetypes'" do
        attribute = %{data-fp-mimetypes="image/png,text/*"}
        expect(form.filepicker_field(:filepicker_url, mimetypes: "image/png,text/*")).to include(attribute)
      end

      it "have correct input with 'extensions'" do
        attribute = %{data-fp-extensions=".png,.jpg"}
        expect(form.filepicker_field(:filepicker_url, extensions: ".png,.jpg")).to include(attribute)
      end

      it "have correct input with 'container'" do
        attribute = %{data-fp-container="window"}
        expect(form.filepicker_field(:filepicker_url, container: "window")).to include(attribute)
      end

      it "have correct input with 'services'" do
        attribute = %{data-fp-services="BOX, COMPUTER, FACEBOOK"}
        expect(form.filepicker_field(:filepicker_url, services: "BOX, COMPUTER, FACEBOOK")).to include(attribute)
      end

      it "have correct input with 'drag_text'" do
        attribute = %{data-fp-drag-text="drag here"}
        expect(form.filepicker_field(:filepicker_url, drag_text: "drag here")).to include(attribute)
      end

      it "have correct input with 'drag_class'" do
        attribute = %{data-fp-drag-class="js-drag"}
        expect(form.filepicker_field(:filepicker_url, drag_class: "js-drag")).to include(attribute)
      end

      it "have correct input with 'store_path'" do
        attribute = %{data-fp-store-path="avatar"}
        expect(form.filepicker_field(:filepicker_url, store_path: "avatar")).to include(attribute)
      end

      it "have correct input with 'store_location'" do
        attribute = %{data-fp-store-location="S3"}
        expect(form.filepicker_field(:filepicker_url, store_location: "S3")).to include(attribute)
      end

      it "have correct input with 'store_access'" do
        attribute = %{data-fp-store-access="public"}
        expect(form.filepicker_field(:filepicker_url, store_access: "public")).to include(attribute)
      end

      it "have correct input with 'multiple'" do
        attribute = %{data-fp-multiple="true"}
        expect(form.filepicker_field(:filepicker_url, multiple: true)).to include(attribute)
      end

      it "have correct input with 'max_size'" do
        attribute = %{data-fp-maxSize="10"}
        expect(form.filepicker_field(:filepicker_url, max_size: 10)).to include(attribute)
      end

      it "have correct input with 'max_files'" do
        attribute = %{data-fp-maxFiles="10"}
        expect(form.filepicker_field(:filepicker_url, max_files: 10)).to include(attribute)
      end

      it "have correct input with 'onchange'" do
        attribute = %{onchange="track()"}
        expect(form.filepicker_field(:filepicker_url, onchange: "track()")).to include(attribute)
      end

      it "have correct input with 'class'" do
        attribute = %{class="js-field"}
        expect(form.filepicker_field(:filepicker_url, class: "js-field")).to include(attribute)
      end

      it "have correct input with 'value'" do
        attribute = %{value="avatar"}
        expect(form.filepicker_field(:filepicker_url, value: "avatar")).to include(attribute)
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

        it "have data-fp-policy attribute" do
          attribute = %{data-fp-policy="eyJleHBpcnkiOjEzNDgwNjAxNjcsImNhbGwiOlsicGljayIsInN0b3JlIl19"}
          expect(form.filepicker_field(:filepicker_url)).to include(attribute)
        end

        it "have data-fp-signature attribute" do
          attribute = %{data-fp-signature="7bbfb03a94967056d4c98140a3ce188ec7a5b575d2cd86fe5528d7fafb3387c3"}
          expect(form.filepicker_field(:filepicker_url)).to include(attribute)
        end
      end
    end
  end
end
