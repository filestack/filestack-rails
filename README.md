# Filepicker::Rails
[![RubyGems][gem_version_badge]][ruby_gems]
[![Travis CI][travis_ci_badge]][travis_ci]
[![Coveralls][coveralls_badge]][coveralls]
[![Code Climate][code_climate_badge]][code_climate]

Adds form, image_tag, and download/save helpers to help you get up and running with [filepicker.io](http://filepicker.io) in Rails.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'filepicker-rails'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install filepicker-rails

Add the filepicker.io javascript library to your layout:

```erb
<%= filepicker_js_include_tag %>
```

Set your API Key in config/application.rb:

```ruby
config.filepicker_rails.api_key = "Your filepicker.io API Key"
```

Set your Secret Key in config/application.rb for signed request support:

```ruby
config.filepicker_rails.secret_key = "Your filepicker.io Secret Key"
```

Set your CDN Path in config/production.rb ([CDN usage](https://developers.inkfilepicker.com/docs/cdn/)):

```ruby
config.filepicker_rails.cdn_host = "Your CDN host name"
```

## Usage

### First create a migration to add the field that will hold your filepicker.io URL

Run the Rails migration generator from the command line:

    $ rails g migration AddNameOfAttrForFilepickerUrlToUser

Then add a column to the model's table of type :string:

```ruby
class AddNameOfAttrForFilepickerUrlToUser < ActiveRecord::Migration
  def up
    add_column :user, :filepicker_url, :string
  end

  def down
    remove_column :user, :filepicker_url
  end
end
```

### Adding an upload field to your form:

```erb
<%= form_for @user do |f| %>
  <div>
    <%= f.label :filepicker_url, "Upload Your Avatar:" %>
    <%= f.filepicker_field :filepicker_url %> <!-- User#filepicker_url is a regular string column -->
  </div>

  <%= f.submit %>
<% end %>
```

Full options list:

* button_text - The text of the upload button.
* button_class - The class of the upload button.
* extensions - The extensions of file types you want to support for this upload. Ex: ".png,.jpg".
* mimetypes - The file types you want to support for this upload. Ex: "image/png,text/*".
* container - Where to show the file picker dialog can be "modal", "window" or the
of an iframe on the page.
* multiple - (true or false) Whether or not multiple uploads can be saved at once.
* services - What services your users can upload to. Ex: "BOX, COMPUTER, FACEBOOK".
* store_path - The path to store the file at within the specified file store.
* store_location - The file is not copied by default. It remains in the original location. If you wish you have the file copied onto your own storage, you can specify where we should put the copy. The only value at the moment is "S3".
* store_access - Should the underlying file be publicly available on its S3 link. Options are "public" and "private", defaults to 'private'.
* dragdrop - (true or false) Whether or not to allow drag-and-drop uploads.
* drag_text - The text of the dragdrop pane.
* drag_class - The class of the dragdrop pane.
* onchange - The onchange event.

### Accessing FilePicker File with OnChange:

Javascript code in the onchange field acts as a callback, which is
called on upload completion. You can specify onchange either in the ERB
template (as shown below), or unobtrusively via jQuery's change event.

```erb
<%= form_for @user do |f| %>
  <div>
    <%= f.label :filepicker_url, "Upload Your Avatar:" %>
    <%= f.filepicker_field :filepicker_url, onchange: 'onPhotoUpload(event)' %>
  </div>

  <%= f.submit %>
<% end %>
```

The callback is called with a special 'event' variable. The variable has a fpfiles (or if not multiple, also fpfile) attribute with information about the files (jQuery users: look under event.originalEvent).

Example fpfiles object:
```javascript
[{
    url: 'https://...',
    data: {
        filename: 'filename.txt',
        size: 100,
        type: 'text/plain'
    }
},{
    url: 'https://...',
    data: {
        filename: 'filename2.jpg',
        size: 9000,
        type: 'image/jpeg'
    }
}]
```

### Displaying an image:

```erb
<%= filepicker_image_tag @user.filepicker_url, w: 160, h: 160, fit: 'clip' %>
```

See [the filepicker.io documentation](https://developers.filepicker.io/docs/web/#fpurl-images) for the full options list.

### Allowing the user to download a file (or upload it to any of the supported services)

```erb
<%= filepicker_save_button "Save", @user.filepicker_url, "image/jpg" %>
```

Full options list:

* container - Where to show the file picker dialog can be "modal", "window" or the
of an iframe on the page.
* services - What services your users can upload to. Ex: "BOX, COMPUTER, FACEBOOK".
* save_as_name - A recommended file name. The user can override this.

### Demo

See a simple demo app [repo](https://github.com/maxtilford/filepicker-rails-demo)

## Versioning

Filepicker::Rails follow the [Semantic Versioning](http://semver.org/).

## Issues

If you have problems, please create a [Github Issue](https://github.com/Ink/filepicker-rails/issues).

## Contributing

Please see [CONTRIBUTING.md](https://github.com/Ink/filepicker-rails/blob/master/CONTRIBUTING.md) for details.

## Credits

Thank you to all the [contributors](https://github.com/Ink/filepicker-rails/graphs/contributors).

[gem_version_badge]: https://badge.fury.io/rb/filepicker-rails.png
[ruby_gems]: http://rubygems.org/gems/filepicker-rails
[travis_ci]: http://travis-ci.org/Ink/filepicker-rails
[travis_ci_badge]: https://travis-ci.org/Ink/filepicker-rails.svg?branch=master
[code_climate]: https://codeclimate.com/github/Ink/filepicker-rails
[code_climate_badge]: https://codeclimate.com/github/Ink/filepicker-rails.png
[coveralls]: https://coveralls.io/r/Ink/filepicker-rails
[coveralls_badge]: https://coveralls.io/repos/Ink/filepicker-rails/badge.png?branch=master

