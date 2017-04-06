RSpec.shared_examples "a filepicker input tag" do

  context "without options" do

    it "be a input tag" do
      regex = %r{\A<input.*/>\z}
      expect(filepicker_input_tag).to match(regex)
    end

    it "has correct data-fp-apikey attribute" do
      attribute = %{data-fp-apikey="123filepickerapikey"}
      expect(filepicker_input_tag).to include(attribute)
    end

    it "has correct id attribute" do
      attribute = %{id="user_filepicker_url"}
      expect(filepicker_input_tag).to include(attribute)
    end

    it "has correct name attribute" do
      attribute = %{name="user[filepicker_url]"}
      expect(filepicker_input_tag).to include(attribute)
    end

    it "has correct type attribute" do
      attribute = %{type="filepicker"}
      expect(filepicker_input_tag).to include(attribute)
    end
  end

  context "with options" do

    it "have correct input with 'dragdrop'" do
      args << { dragdrop: true }
      attribute = %{type="filepicker-dragdrop"}
      expect(filepicker_input_tag).to include(attribute)
    end

    it "have correct input with 'button_text'" do
      args << { button_text: "upload" }
      attribute = %{data-fp-button-text="upload"}
      expect(filepicker_input_tag).to include(attribute)
    end

    it "have correct input with 'button_class'" do
      args << { button_class: "button" }
      attribute = %{data-fp-button-class="button"}
      expect(filepicker_input_tag).to include(attribute)
    end

    it "have correct input with 'mimetypes'" do
      args << { mimetypes: "image/png,text/*" }
      attribute = %{data-fp-mimetypes="image/png,text/*"}
      expect(filepicker_input_tag).to include(attribute)
    end

    it "have correct input with 'extensions'" do
      args << { extensions: ".png,.jpg" }
      attribute = %{data-fp-extensions=".png,.jpg"}
      expect(filepicker_input_tag).to include(attribute)
    end

    it "have correct input with 'container'" do
      args << { container: "window" }
      attribute = %{data-fp-container="window"}
      expect(filepicker_input_tag).to include(attribute)
    end

    it "have correct input with 'services'" do
      args << { services: "BOX, COMPUTER, FACEBOOK" }
      attribute = %{data-fp-services="BOX, COMPUTER, FACEBOOK"}
      expect(filepicker_input_tag).to include(attribute)
    end

    it "have correct input with 'drag_text'" do
      args << { drag_text: "drag here" }
      attribute = %{data-fp-drag-text="drag here"}
      expect(filepicker_input_tag).to include(attribute)
    end

    it "have correct input with 'drag_class'" do
      args << { drag_class: "js-drag" }
      attribute = %{data-fp-drag-class="js-drag"}
      expect(filepicker_input_tag).to include(attribute)
    end

    it "have correct input with 'store_path'" do
      args << { store_path: "avatar" }
      attribute = %{data-fp-store-path="avatar"}
      expect(filepicker_input_tag).to include(attribute)
    end

    it "have correct input with 'store_location'" do
      args << { store_location: "S3" }
      attribute = %{data-fp-store-location="S3"}
      expect(filepicker_input_tag).to include(attribute)
    end

    it "have correct input with 'store_container'" do
      args << { store_container: "my-bucket" }
      attribute = %{data-fp-store-container="my-bucket"}
      expect(filepicker_input_tag).to include(attribute)
    end

    it "have correct input with 'store_access'" do
      args << { store_access: "public" }
      attribute = %{data-fp-store-access="public"}
      expect(filepicker_input_tag).to include(attribute)
    end

    it "have correct input with 'multiple'" do
      args << { multiple: true }
      attribute = %{data-fp-multiple="true"}
      expect(filepicker_input_tag).to include(attribute)
    end

    it "have correct input with 'max_size'" do
      args << { max_size: 10 }
      attribute = %{data-fp-maxSize="10"}
      expect(filepicker_input_tag).to include(attribute)
    end

    it "have correct input with 'max_files'" do
      args << { max_files: 10 }
      attribute = %{data-fp-maxFiles="10"}
      expect(filepicker_input_tag).to include(attribute)
    end

    it "have correct input with 'open_to'" do
      args << { open_to: 'FACEBOOK' }
      attribute = %{data-fp-openTo="FACEBOOK"}
      expect(filepicker_input_tag).to include(attribute)
    end

    it "have correct input with 'onchange'" do
      args << { onchange: "track()" }
      attribute = %{onchange="track()"}
      expect(filepicker_input_tag).to include(attribute)
    end

    it "have correct input with 'class'" do
      args << { :class => "js-field" }
      attribute = %{class="js-field"}
      expect(filepicker_input_tag).to include(attribute)
    end

    it "have correct input with 'value'" do
      args << { value: "avatar" }
      attribute = %{value="avatar"}
      expect(filepicker_input_tag).to include(attribute)
    end

    it "have correct input with 'language'" do
      args << { language: 'fr' }
      attribute = %{data-fp-language="fr"}
      expect(filepicker_input_tag).to include(attribute)
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
        expect(filepicker_input_tag).to include(attribute)
      end

      it "have data-fp-signature attribute" do
        attribute = %{data-fp-signature="7bbfb03a94967056d4c98140a3ce188ec7a5b575d2cd86fe5528d7fafb3387c3"}
        expect(filepicker_input_tag).to include(attribute)
      end
    end
  end
end
