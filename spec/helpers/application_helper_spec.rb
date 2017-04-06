require 'rails_helper'

RSpec.describe FilepickerRails::ApplicationHelper do

  describe "#filepicker_js_include_tag" do

    it "be a script tag" do
      regex = %r{\A<script.*></script>\z}
       expect(filepicker_js_include_tag).to match(regex)
    end

    it "include the correct type" do
      attribute = %{type="text/javascript"}
      expect(filepicker_js_include_tag).to include(attribute)
    end

    it "has correct src attribute" do
      attribute = %{src="//api.filepicker.io/v2/filepicker.js"}
      expect(filepicker_js_include_tag).to include(attribute)
    end
  end

  describe "#filepicker_field_tag" do

    include_examples "a filepicker input tag" do
      let(:args) do
        ['user[filepicker_url]']
      end

      let(:filepicker_input_tag) do
        filepicker_field_tag(*args)
      end
    end
  end

  describe "#filepicker_save_button" do

    context "without options" do

      it "be a button tag" do
        regex = %r{\A<button .*>save</button>\z}
        expect(filepicker_save_button('save', '/foo', 'image/jpg')).to match(regex)
      end

      it "have the data-fp-apikey attribute" do
        attribute = %{data-fp-apikey="123filepickerapikey"}
        expect(filepicker_save_button('save', '/foo', 'image/jpg')).to include(attribute)
      end

      it "have the data-fp-mimetype attribute" do
        attribute = %{data-fp-mimetype="image/jpg"}
        expect(filepicker_save_button('save', '/foo', 'image/jpg')).to include(attribute)
      end

      it "have the data-fp-url attribute" do
        attribute = %{data-fp-url="/foo"}
        expect(filepicker_save_button('save', '/foo', 'image/jpg')).to include(attribute)
      end

      it "have the name attribute" do
        attribute = %{name="button"}
        expect(filepicker_save_button('save', '/foo', 'image/jpg')).to include(attribute)
      end

      it "have the type attribute" do
        attribute = %{type="submit"}
        expect(filepicker_save_button('save', '/foo', 'image/jpg')).to include(attribute)
      end
    end

    context "with options" do

      describe "container" do

        it "have the data-fp-container attribute" do
          attribute = %{data-fp-container="modal"}
          expect(filepicker_save_button('save', '/foo', 'image/jpg', container: 'modal')).to include(attribute)
        end
      end

      describe "services" do

        it "have the data-fp-services attribute" do
          attribute = %{data-fp-services="COMPUTER, FACEBOOK"}
          expect(filepicker_save_button('save', '/foo', 'image/jpg', services: 'COMPUTER, FACEBOOK')).to include(attribute)
        end
      end

      describe "suggestedFilename" do

        it "have the data-fp-suggestedFilename attribute" do
          attribute = %{data-fp-suggestedFilename="myfile"}
          expect(filepicker_save_button('save', '/foo', 'image/jpg', save_as_name: 'myfile')).to include(attribute)
        end
      end
    end
  end

  describe "#filepicker_save_link" do

    context 'without options' do
      it 'have the correct link' do
        expect(filepicker_save_link('save', '/foo', 'image/jpg')).to eq(build_link)
      end
    end

    context "with options" do

      describe "container" do

        it "have the correct link" do
          expect(filepicker_save_link('save', '/foo', 'image/jpg', container: 'modal')).to eq(build_link('fp-container' => 'modal'))
        end
      end

      describe "services" do

        it "have the correct link" do
          expect(filepicker_save_link('save', '/foo', 'image/jpg', services: 'COMPUTER, FACEBOOK')).to eq(build_link('fp-services' => 'COMPUTER, FACEBOOK'))
        end
      end

      describe "suggestedFilename" do

        it "have the correct link" do
          expect(filepicker_save_link('save', '/foo', 'image/jpg', save_as_name: 'myfile')).to eq(build_link('fp-suggestedFilename' => 'myfile'))
        end
      end
    end

    def build_link(options = {})
      default_options = { 'fp-url' => '/foo',
                          'fp-apikey' => '123filepickerapikey',
                          'fp-mimetype' => 'image/jpg',
      }
      data =  default_options.merge(options)
      link_to 'save', '#', data: data, id: 'filepicker_export_widget_link'
    end
  end

  describe "#filepicker_image_tag" do

    context "only with url" do

      it "be a img tag" do
        regex = %r{\A<img .*/>\z}
        expect(filepicker_image_tag("foo")).to match(regex)
      end

      it "has correct src attribute" do
        attribute = %{src="/images/foo"}
        expect(filepicker_image_tag("foo")).to include(attribute)
      end

      it "has correct alt attribute" do
        attribute = %{alt="Foo"}
        expect(filepicker_image_tag("foo")).to include(attribute)
      end
    end

    context "with image_options" do

      it "has correct src attribute" do
        attribute = %{src="/images/foo/convert?h=160&amp;w=160"}
        expect(filepicker_image_tag("foo", w: 160, h: 160)).to include(attribute)
      end

      it "has correct alt attribute" do
        attribute = %{alt="Convert?h=160&amp;w=160"}
        expect(filepicker_image_tag("foo", w: 160, h: 160)).to include(attribute)
      end
    end

    context "with image_tag_options" do

      it "have correct image tag" do
        html = %{<img alt="Foo image" src="/images/foo" />}
        expect(filepicker_image_tag("foo", {}, alt: "Foo image")).to eq(html)
      end
    end
  end

  describe "#filepicker_image_url" do

    context "only with url" do

      it "have correct url" do
        expect(filepicker_image_url("foo")).to eq('foo')
      end
    end

    context "with options" do

      it "have correct url with a invalid param" do
        expect(filepicker_image_url("foo", wrong: 'top')).to eq('foo')
      end

      it "have correct url with 'w'" do
        expect(filepicker_image_url("foo", w: 160)).to eq('foo/convert?w=160')
      end

      it "have correct url with 'h'" do
        expect(filepicker_image_url("foo", h: 60)).to eq('foo/convert?h=60')
      end

      it "have correct url with 'fit'" do
        expect(filepicker_image_url("foo", fit: 'clip')).to eq('foo/convert?fit=clip')
      end

      it "have correct url with 'align'" do
        expect(filepicker_image_url("foo", align: 'faces')).to eq('foo/convert?align=faces')
      end

      it "have correct url with 'rotate'" do
        expect(filepicker_image_url("foo", rotate: 'exif')).to eq('foo/convert?rotate=exif')
      end


      it "have correct url with 'crop'" do
        expect(filepicker_image_url("foo", crop: '20,30,400,200')).to eq('foo/convert?crop=20%2C30%2C400%2C200')
      end

      it "have correct url with 'format'" do
        expect(filepicker_image_url("foo", format: 'png')).to eq('foo/convert?format=png')
      end

      it "have correct url with 'quality'" do
        expect(filepicker_image_url("foo", quality: 80)).to eq('foo/convert?quality=80')
      end

      it "have correct url with 'watermark'" do
        url = 'foo/convert?watermark=http%3A%2F%2Fwww.google.com%2Fimages%2Fsrpr%2Flogo4w.png'
        expect(filepicker_image_url("foo", watermark: 'http://www.google.com/images/srpr/logo4w.png')).to eq(url)
      end

      it "have correct url with 'watersize'" do
        expect(filepicker_image_url("foo", watersize: 70)).to eq('foo/convert?watersize=70')
      end

      it "have correct url with 'waterposition'" do
        expect(filepicker_image_url("foo", waterposition: 'top')).to eq('foo/convert?waterposition=top')
      end

      it "have correct url with 'crop_first'" do
        url = 'foo/convert?crop_first=true'
        expect(filepicker_image_url("foo", crop_first: true)).to eq(url)
      end

      describe 'cache' do

        it "have correct url with 'cache' only" do
          expect(filepicker_image_url("foo", cache: true)).to eq('foo?cache=true')
        end

        it "have correct url with 'cache' and convert option" do
          url = 'foo/convert?align=faces&cache=true'
          expect(filepicker_image_url("foo", cache: true, align: 'faces')).to eq(url)
        end
      end

      describe 'compress' do

        it "have correct url with 'compress' only" do
          expect(filepicker_image_url("foo", compress: true)).to eq('foo?compress=true')
        end

        it "have correct url with 'compress' and convert option" do
          url = 'foo/convert?align=faces&compress=true'
          expect(filepicker_image_url("foo", compress: true, align: 'faces')).to eq(url)
        end
      end

      describe "when convert options is already in the url" do

        it "merges the options into the query params" do
          url = filepicker_image_url("foo/convert?crop=0,0,1024,1024", watersize: 70)
          expect(url).to eq("foo/convert?crop=0%2C0%2C1024%2C1024&watersize=70")
        end
      end
    end

    context "with cdn host" do

      before do
        Rails.application.config.filepicker_rails.cdn_host = "//cdn.example.com"
      end

      let(:url) do
        "https://www.filepicker.io/foo"
      end

      it "have url with cdn host" do
        expect(filepicker_image_url(url)).to eq("//cdn.example.com/foo")
      end

      it "do not change the original url" do
        expect do
          filepicker_image_url(url)
        end.to_not change { url }
      end
    end

    context 'with policy' do

      before do
        Timecop.freeze(Time.zone.parse("2012-09-19 12:59:27"))
        Rails.application.config.filepicker_rails.secret_key = 'filepicker123secretkey'
      end

      after do
        Timecop.return
        Rails.application.config.filepicker_rails.secret_key = nil
      end

      it 'have policy and signature' do
        url = 'foo?policy=eyJleHBpcnkiOjEzNDgwNjAxNjcsImNhbGwiOlsicmVhZCIsImNvbnZlcnQiXSwiaGFuZGxlIjoiZm9vIn0%3D' \
              '&signature=bccb3bdfc0cb1dfc7cff1bafebd659bb5a8f1a1a3a93e9d80a32b004cd4ab939'
        expect(filepicker_image_url('foo')).to eq(url)
      end

      it 'have different policy and signature with a different handle' do
        url = 'bar?policy=eyJleHBpcnkiOjEzNDgwNjAxNjcsImNhbGwiOlsicmVhZCIsImNvbnZlcnQiXSwiaGFuZGxlIjoiYmFyIn0%3D' \
                  '&signature=687ed74d2d113b77069c4aac836cb4d1b947cff8e7dba920869b47e4e03ff6b6'
        expect(filepicker_image_url('bar')).to eq(url)
      end

      it 'have policy and signature when have some convert option' do
        url = 'foo/convert' \
              '?policy=eyJleHBpcnkiOjEzNDgwNjAxNjcsImNhbGwiOlsicmVhZCIsImNvbnZlcnQiXSwiaGFuZGxlIjoiZm9vIn0%3D' \
              '&quality=80' \
              '&signature=bccb3bdfc0cb1dfc7cff1bafebd659bb5a8f1a1a3a93e9d80a32b004cd4ab939'
        expect(filepicker_image_url('foo', quality: 80)).to eq(url)
      end
    end
  end
end
