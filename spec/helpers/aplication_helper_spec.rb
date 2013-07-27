require 'spec_helper'

describe FilepickerRails::ApplicationHelper do

  describe "#filepicker_js_include_tag" do

    it "have correct output" do
      expect(filepicker_js_include_tag).to eq(%{<script src="//api.filepicker.io/v1/filepicker.js"></script>})
    end
  end

  describe "#filepicker_save_button" do

    context "without options" do

      it "have the correct button" do
        html = %{<button data-fp-apikey="123filepickerapikey"}
        html << %{ data-fp-mimetype="image/jpg" data-fp-url="/foo" name="button"}
        html << %{ type="submit">save</button>}
        expect(filepicker_save_button('save', '/foo', 'image/jpg')).to eq(html)
      end
    end

    context "with options" do

      describe "container" do

        it "have the correct button" do
          html = %{<button data-fp-apikey="123filepickerapikey"}
          html << %{ data-fp-mimetype="image/jpg" data-fp-option-container=\"modal\" data-fp-url="/foo"}
          html << %{ name="button" type="submit">save</button>}
          expect(filepicker_save_button('save', '/foo', 'image/jpg', container: 'modal')).to eq(html)
        end
      end

      describe "services" do

        it "have the correct button" do
          html = %{<button data-fp-apikey="123filepickerapikey"}
          html << %{ data-fp-mimetype="image/jpg" data-fp-option-services="COMPUTER, FACEBOOK"}
          html << %{ data-fp-url="/foo" name="button" type="submit">save</button>}
          expect(filepicker_save_button('save', '/foo', 'image/jpg', services: 'COMPUTER, FACEBOOK')).to eq(html)
        end
      end

      describe "save_as_name" do

        it "have the correct button" do
          html = %{<button data-fp-apikey="123filepickerapikey"}
          html << %{ data-fp-mimetype="image/jpg" data-fp-option-defaultSaveasName="myfile"}
          html << %{ data-fp-url="/foo" name="button" type="submit">save</button>}
          expect(filepicker_save_button('save', '/foo', 'image/jpg', save_as_name: 'myfile')).to eq(html)
        end
      end
    end
  end

  describe "#filepicker_image_tag" do

    context "only with url" do

      it "have correct image tag" do
        expect(filepicker_image_tag("foo")).to eq(%{<img alt="Convert?" src="/images/foo/convert?" />})
      end
    end

    context "with image_options" do

      it "have correct image tag" do
        html = %{<img alt="Convert?h=160&amp;w=160" src="/images/foo/convert?h=160&amp;w=160" />}
        expect(filepicker_image_tag("foo", w: 160, h: 160)).to eq(html)
      end
    end

    context "with image_tag_options" do

      it "have correct image tag" do
        html = %{<img alt="Foo image" src="/images/foo/convert?" />}
        expect(filepicker_image_tag("foo", {}, alt: "Foo image")).to eq(html)
      end
    end
  end
end
