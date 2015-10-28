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

Set your API Key in `config/application.rb`:

```ruby
config.filepicker_rails.api_key = "Your filepicker.io API Key"
```

## Usage

### First create a migration to add the field that will hold your filepicker.io URL

Run the Rails migration generator from the command line:

    $ rails g migration AddNameOfAttrForFilepickerUrlToUser

Then add a column to the model's table of type :string:

```ruby
class AddNameOfAttrForFilepickerUrlToUser < ActiveRecord::Migration
  def change
    add_column :user, :filepicker_url, :string
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
The `filepicker_field` accepts a options parameter, [click here to see all the valid options](http://rubydoc.info/github/Ink/filepicker-rails/master/FilepickerRails/FormHelper:filepicker_field).

### Displaying an image:

```erb
<%= filepicker_image_tag @user.filepicker_url, w: 160, h: 160, fit: 'clip' %>
```

The `filepicker_image_tag` accepts a options parameter, [click here to see all the valid options](http://rubydoc.info/github/Ink/filepicker-rails/master/FilepickerRails/ApplicationHelper:filepicker_image_url).

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

### Allowing the user to download a file (or upload it to any of the supported services)

```erb
<%= filepicker_save_button "Save", @user.filepicker_url, "image/jpg" %>
```

The `filepicker_save_button` accepts a options parameter, [click here to see all the valid options](http://rubydoc.info/github/Ink/filepicker-rails/master/FilepickerRails/ApplicationHelper:filepicker_save_button).

### CDN

Set your CDN Path in `config/production.rb` ([CDN usage](https://www.filepicker.com/documentation/cdn/)):

```ruby
config.filepicker_rails.cdn_host = "Your CDN host name"
```

### Policy

To use the [filepicker policies](https://www.filepicker.com/documentation/security/) follow this instructions.

Set your Secret Key in `config/application.rb`

```ruby
config.filepicker_rails.secret_key = "Your filepicker.io Secret Key"
```

#### Expiry time

By default the expiry time is 10 minutes. If you need to change the expiry time this should be an integer and it is expressed in seconds since the [Epoch](http://en.wikipedia.org/wiki/Unix_time).

So you can do something like that to set the expiry time to 5 minutes.

```ruby
config.filepicker_rails.expiry = -> { (Time.zone.now + 5.minutes).to_i }
```

If you need always the same url, a static expiry time, to do some cache. You can set a date starting of the Epoch.

```ruby
-> { 100.years.since(Time.at(0)).to_i }
```

The argument need to be a [callable](http://www.rubytapas.com/episodes/35-Callable).

## Demo

See a simple demo app [repo](https://github.com/maxtilford/filepicker-rails-demo)

## RDocs

You can view the Filepicker::Rails documentation in RDoc format here:

http://rubydoc.info/github/Ink/filepicker-rails/master/frames

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

