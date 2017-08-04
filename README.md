[![Travis CI][travis_ci_badge]][travis_ci]
[![Coveralls][coveralls_badge]][coveralls]
[![Code Climate][code_climate_badge]][code_climate]

# Filestack::Rails
<a href="https://www.filestack.com"><img src="https://filestack.com/themes/filestack/assets/images/press-articles/color.svg" align="left" hspace="10" vspace="6"></a>
This is the official Rails plugin for Filestack - API and content management system that makes it easy to add powerful file uploading and transformation capabilities to any web or mobile application.

## Resources

* [Filestack](https://www.filestack.com)
* [Documentation](https://www.filestack.com/docs)
* [API Reference](https://filestack.github.io/)

## IMPORTANT
Users of 3.0.0 wishing to upgrade to 3.1.0+ should note that the Filestack::Ruby dependency has been updated to no longer interfere with namespace. However, if you were using that dependency in your Rails app, you will need to change any Client and Filelink class declarations to FilestackClient and FilestackFilelink, as per documented [here](https://github.com/filestack/filestack-ruby/blob/master/README.md)

## Installing

Add this line to your application's Gemfile:

```ruby
gem 'filestack-rails'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install filestack-rails

Add the Filestack File Picker and initialization script to your layout:

```erb
<%= filestack_js_include_tag %>
<%= filestack_js_init_tag %> 
```

Please note: the scripts need to be added before your application's custom scripts, e.g. before any scripts in your assets folder, if you need access the Filestack client in your own Javascript. 

Set your API key and client name in `config/application.rb`:

```ruby
config.filestack_rails.api_key = "Your Filestack API Key"
config.filestack_rails.client_name = "custom_client_name"
```
The client name defaults to "filestack_client" and is injected into your client-side Javascript. This is because v3 of the File Picker lives in the Javascript of your web application. For more information, please see our [File Picker documenation](https://www.filestack.com/docs/javascript-api/pick-v3). 

### Security

If your account has security enabled, then you must initialize the File Picker with a signature and policy. This is easily enabled through the configuration options by setting your application secret and security options:

```erb
config.filestack_rails.app_secret = 'YOUR_APP_SECRET'
config.filestack_rails.security = {'call' => %w[pick store read convert] }
```
If you set security to an empty object like so
```erb
config.filestack_rails.security = {}
```
it will provide a policy and signature with only an expiry setting (this defaults to one hour).

You can access the generated policy and signature anytime by calling their attributes on the created security object:

```erb
puts config.filestack_rails.security.policy
puts config.filestack_rails.security.signature
```
You can also generate a new security object at any time, although this will only affect the filestack_image tag, and not the File Picker client. 

## Usage

Filestack::Rails provides three main functionalities: 

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
## Migrating from 2.x to 3.x
Filestack::Rails 3.x is a significant and breaking change. Users wishing to upgrade will need to change their current implementation in order to use the plugin correctly. 
### Javascript-based File Picker
The v3 File Picker is a Javascript application that lives on the client-side of your application. This means you have greater control and access to when it is called, access to the rest of the web SDK, as well as being able to pass callbacks executed once uploads have completed. You must keep in mind the File Picker client lives in global scope and adjust your namespaces accordingly, although you can also change the name of the client, as detailed in the above sections.
### Form Helper
The form helper's call remains essentially the same, except that it now takes as its argument the value of the button element displayed on the page. 
```erb
<%= f.filestack_field :filestack_url, 'Pick Your Avatar' >
```
### Save Button
As user saving/downloading is not currently supported in the v3 File Picker, that functionality has been removed from Filestack::Rails for the time being. 
### Transformations
The filestack_image tag wraps the generic Rails image_tag and generates a new URL with use of the Ruby SDK. This provides the entire scope of the possible transformations through Filestack's transformation engine, minus those which do not return an image (like debug, av_convert, and so forth). Defining transformations is as simple as chaining them together using the filestack_transform method:
```erb
<%= @user.filestack_url, transform: filestack_transform.resize(width:100, height:100).enhance %>
```
### Ruby SDK
Filestack::Rails injects the Filestack Ruby SDK into your application for use anywhere. You can use it to access the rest of the Filestack API and find its documentation [here](https://github.com/filestack/filestack-ruby)
## Demo

To see the Filestack::Rails plugin in action, clone this repository and run the demo app by following these instructions (will only work in Rails 5.x): 

### Set API key

Go to ```spec/dummy/config/application.rb``` and change the API key to your own. 

### Install Dependencies

Navigate to the ```spec/dummy``` folder and run:
```
$ bundle install
```

### Migrate User Database

The form field requires a User model, which has been predefined, and so you need to migrate the database:
```
rails db:migrate
```

### Run Server

While in the ```spec/dummy``` directory, run the server
```
rails s
```
and navigate to http://localhost:3000.

## Versioning

Filestack::Rails follows the [Semantic Versioning](http://semver.org/).

## Issues

If you have problems, please create a [Github Issue](https://github.com/filepicker/filestack-rails/issues).

## Contributing

Please see [CONTRIBUTING.md](https://github.com/filepicker/filestack-rails/CONTRIBUTING.md) for details.

## Credits

Thank you to all the [contributors](https://github.com/filepicker/filestack-rails/graphs/contributors).

[gem_version_badge]: https://badge.fury.io/rb/filestack-rails.svg
[ruby_gems]: http://rubygems.org/gems/filestack-rails
[travis_ci]: http://travis-ci.org/filestack/filestack-rails
[travis_ci_badge]: https://travis-ci.org/filestack/filestack-rails.svg?branch=master
[code_climate]: https://codeclimate.com/github/filestack/filestack-rails
[code_climate_badge]: https://codeclimate.com/github/filestack/filestack-rails.png
[coveralls]: https://coveralls.io/github/filestack/filestack-rails?branch=master
[coveralls_badge]: https://coveralls.io/repos/github/filestack/filestack-rails/badge.svg?branch=master