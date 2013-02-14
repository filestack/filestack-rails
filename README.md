# Filepicker::Rails

Adds form, image_tag, and download/save helpers to help you get up and running with [filepicker.io](http://filepicker.io) in Rails.

## Installation

Add this line to your application's Gemfile:

    gem 'filepicker-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install filepicker-rails

Add the filepicker.io javascript library to your layout:

    <%= filepicker_js_include_tag %>

Set your API Key in config/application.rb:

    config.filepicker_rails.api_key = "Your filepicker.io API Key"

## Usage
### First create a migration to add the field that will hold your filepicker.io URL  
Run the Rails migration generator from the command line:      
    
    $ rails g migration AddNameOfAttrForFilepickerUrlToUser  
    
Then add a column to the model's table of type :string:    

    class AddNameOfAttrForFilepickerUrlToUser < ActiveRecord::Migration
        def up
            add_column :user, :filepicker_url, :string
        end

        def down
            remove_column :user, :filepicker_url
        end
    end  
    
    
    
### Adding an upload field to your form:

    <%= form_for @user do |f| %>
      <div>
        <%= f.label :filepicker_url, "Upload Your Avatar:" %>
        <%= f.filepicker_field :filepicker_url %> <!-- User#filepicker_url is a regular string column -->
      </div>

      <%= f.submit %>
    <% end %>

Full options list:

* button_text - The text of the upload button.
* button_class - The class of the upload button.
* mimetypes - The file types you want to support for this upload. Ex: "image/png,text/*".
* container - Where to show the file picker dialog can be "modal", "window" or the
of an iframe on the page.
* multiple - (true or false) Whether or not multiple uploads can be saved at once.
* services - What services your users can upload to. Ex: "BOX, COMPUTER, FACEBOOK".
* dragdrop - (true or false) Whether or not to allow drag-and-drop uploads.
* drag_text - The text of the dragdrop pane.
* drag_class - The class of the dragdrop pane.
* onchange - The onchange event.


### Displaying an image:

    <%= filepicker_image_tag @user.filepicker_url, w: 160, h: 160, fit: 'clip' %>

See [the filepicker.io documentation](https://developers.filepicker.io/docs/web/#fpurl-images) for the full options list.


### Allowing the user to download a file (or upload it to any of the supported services)

    <%= filepicker_save_button "Save", @user.filepicker_url, "image/jpg" %>

Full options list:

* container - Where to show the file picker dialog can be "modal", "window" or the
of an iframe on the page.
* services - What services your users can upload to. Ex: "BOX, COMPUTER, FACEBOOK".
* save_as_name - A recommended file name. The user can override this.

### Demo

See a simple demo app [repo](https://github.com/maxtilford/filepicker-rails-demo)
