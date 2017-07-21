# Filepicker::Rails
[![RubyGems][gem_version_badge]][ruby_gems]
[![Travis CI][travis_ci_badge]][travis_ci]
[![Coveralls][coveralls_badge]][coveralls]
[![Code Climate][code_climate_badge]][code_climate]

Adds form, image_tag, and download/save helpers to help you get up and running with [filestack.com](http://filestack.com) in Rails.

## Note

This gem was previously named filepicker-rails (up to 2.1.0 version).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'filestack-rails', require: 'filestack-rails'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install filestack-rails

Add the Filestack Uploader and initialization script to your layout:

```erb
<%= filestack_js_include_tag %>
<%= filestack_js_init_tag %> 
```

Please note: the scripts need to be added in that order and before your application's custom scripts, e.g. before any scripts in your assets folder.

Set your API key and client name in `config/application.rb`:

```ruby
config.filestack_rails.api_key = "Your Filestack API Key"
config.filestack_rails.client_name = "custom_client_name"

```
The client name defaults to "filestack_client" and is injected into your client-side Javascript. This is because v3 of the File Picker lives in the Javascript of your web application. For more information, please see our [File Picker documenation](https://www.filestack.com/docs/javascript-api/pick-v3). 

## Usage

The Filestack-Rails plugin provides three main functionalities: 

### Filestack Upload Button
This is a generic button that can be added anywhere in your application and opens an instance of the File Picker. Once a user has chosen a file(s) and submitted, a callback will be executed, passing in the results. You can also pass in any options for the File Picker using the pickerOptions symbol:

```erb
<%= filestack_picker_element 'button test', 'callbackForButton', id: 'someuniequeid', pickerOptions: { 'fromSources' => 'facebook' } %>
```
File Picker options are exactly the same as in the Javscript SDK and can be found in the aforementioned documentation. 

The callback can be either the name of a function you've defined in your main Javascript or it can be any code that is immediately executable, e.g. "console.log" or "(function(data){console.log(data)})". The callback should take in a response array as its only argument, which has the following structure:

```javascript
{
    "filesUploaded": [
        {
            "filename":"Birds",
            "handle":"unique_filestack_handle",
            "mimetype":"image/jpeg",
            "originalPath":"/bird/flickr/3/2849/9533051578_377332e54c_z.jpg/Birds",
            "size":121727,
            "source":"imagesearch",
            "url":"https://cdn.filestackcontent.com/unique_filestack_handle",
            "key":"fnZb1ElSMmKCLPNaErRU_bird.jpg",
            "container":"filestack-website-uploads"
        },
        {
            "filename": ...
        }
    ],
    "filesFailed": []
}
```

Each file that is uploaded will be represented as a single object within the filesUploaded array. Accessing the first file uploaded in the callback would be achieved like so:
```javascript
url = data.filesUploaded[0].url
```

### Filestack Form Helper
The form helper wraps the generic Pick element and adds the value of the returned file to an invisible text element, in order to attach to the form. It accepts the same options as the Pick element and renders the same button.

```erb
<%= form_for @user do |f| %>
  <div>
    <%= f.filestack_field :filepicker_url, 'Upload Your Avatar!',  pickerOptions: {'fromSources': 'facebook'}, id: 'unique-id' %> 
  </div>

  <%= f.submit %>
<% end %>
```


### Displaying an image with Filestack Transformations:
Filestack::Rails now has access to the full list of image transforms through our custom Transformation Engine. This functionality is provided by the Filestack Ruby SDK and acts as a small wrapper around it. The filestack_image tag accepts the same options as the genric Rails image_tag, with the addition of a transform option, which accepts a filestack_transform chain:

```erb
<%= filestack_image @user.filepicker_url, transform: filestack_transform.resize(width:100, height:100).flip.enhance %>
```

## Demo

See a simple demo app [repo](https://github.com/maxtilford/filepicker-rails-demo)

## RDocs

You can view the Filepicker::Rails documentation in RDoc format here:

http://rubydoc.info/github/filestack/filepicker-rails/master/frames

## Versioning

Filestack::Rails follow the [Semantic Versioning](http://semver.org/).

## Issues

If you have problems, please create a [Github Issue](https://github.com/filestack/filepicker-rails/issues).

## Contributing

Please see [CONTRIBUTING.md](https://github.com/filestack/filepicker-rails/blob/master/CONTRIBUTING.md) for details.

## Credits

Thank you to all the [contributors](https://github.com/filestack/filepicker-rails/graphs/contributors).

[gem_version_badge]: https://badge.fury.io/rb/filestack-rails.svg
[ruby_gems]: http://rubygems.org/gems/filestack-rails
[travis_ci]: http://travis-ci.org/filestack/filestack-rails
[travis_ci_badge]: https://travis-ci.org/filestack/filestack-rails.svg?branch=master
[code_climate]: https://codeclimate.com/github/filestack/filestack-rails
[code_climate_badge]: https://codeclimate.com/github/filestack/filestack-rails.png
[coveralls]: https://coveralls.io/github/filestack/filestack-rails?branch=master
[coveralls_badge]: https://coveralls.io/repos/github/filestack/filestack-rails/badge.svg?branch=master