require 'rails_helper'

describe FilepickerRails::ApplicationHelper do

  describe "#filepicker_js_include_tag" do

    it "be a script tag" do
      regex = %r{\A<script.*></script>\z}
       expect(filepicker_js_include_tag).to match(regex)
    end

    it "has correct src attribute" do
      attribute = %{src="//api.filepicker.io/v1/filepicker.js"}
      expect(filepicker_js_include_tag).to include(attribute)
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
        expect(filepicker_image_tag("foo")).to eq(%{<img alt="Foo" src="/images/foo" />})
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

      it "have correct url with 'cache'" do
        expect(filepicker_image_url("foo", cache: true)).to eq('foo?cache=true')
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
        Rails.application.config.filepicker_rails.secret_key = 'filepicker123secretkey'
      end

      after do
        Rails.application.config.filepicker_rails.secret_key = nil
      end

      it 'have policy and signature' do
        expiry = Time.now.to_i
        FilepickerRails::Policy.any_instance.stub(:expiry).and_return(expiry)
        json_policy = {expiry: expiry, call: [:read, :convert]}.to_json
        policy = Base64.urlsafe_encode64(json_policy)
        signature = OpenSSL::HMAC.hexdigest('sha256', 'filepicker123secretkey', policy)
        url = "foo?#{{policy: policy, signature: signature}.to_param}"
        expect(filepicker_image_url('foo')).to eq(url)
      end

      it 'have policy and signature when have some convert option' do
        expiry = Time.now.to_i
        FilepickerRails::Policy.any_instance.stub(:expiry).and_return(expiry)
        json_policy = {expiry: expiry, call: [:read, :convert]}.to_json
        policy = Base64.urlsafe_encode64(json_policy)
        signature = OpenSSL::HMAC.hexdigest('sha256', 'filepicker123secretkey', policy)
        url = "foo/convert?#{{policy: policy, quality: 80, signature: signature}.to_param}"
        expect(filepicker_image_url('foo', quality: 80)).to eq(url)
      end
    end
  end
end
