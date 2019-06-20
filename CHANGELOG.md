# Changelog

## 4.0.5 (June 20, 2019)
- Fix issue with creating security (policy and signature) per request

## 4.0.4 (June 19, 2019)
- Fix issue with security in v3
- Update link to Github Issues

## 4.0.3 (March 25, 2019)
- Fix gem version

## 4.0.2 (March 25, 2019)
- Update filestack-ruby gem to ver. 2.6.0

## 4.0.1 (February 1, 2019)
- Fixed the issue with not loaded lib module

## 4.0.0 (January 23, 2019)
- Update Filestack Picker to ver. 1.x.x and add version configuration

## 3.2.2 (January 18, 2019)
- Fixed typo in exception message

## 3.2.1 (October 10, 2018)
- Update filestack-ruby gem to ver. 2.5.0

## 3.2.0 (August 30, 2018)
- Update filestack-ruby gem to ver. 2.4.0

## 3.1.1 (April 11, 2018)
- Add CNAME parameter

## 3.1.0 (August 4, 2017)
- Update Filestack::Ruby dependency to latest version to address namespacing issue

## 3.0.0 (July 24, 2017)
- Update to use v3 of Filestack File Picker
- Add filestack_picker_element as a general uploading button
- Various additions and removals surrounding the aforementioned elements

## 2.2.0 (April, 05, 2017)

- Move repository to Filestack organisation.
- Rename gem to filestack-rails.
- Add support for Ruby 2.3.0 and 2.4.1.
- Remove support for Ruby 1.9.3 and Ruby 2.0.0.
- Add helper support for Rails 5 [Fixes #153](https://github.com/filestack/filestack-rails/issues/153).
- Include handle when generating secure urls [Fixes #116](https://github.com/Ink/filepicker-rails/issues/116).
  This ensures that all policies and signatures are unique.
- Support for [`language`](https://www.filepicker.com/docs/file-ingestion/javascript-api/language?v=v2) dialog option.
- Add support for compress argument.
- Fix data-fp-services and data-fp-suggestedFilename options for filepicker_save_link.

## 2.1.0 (October, 07, 2015)

- Support for
  [`crop_first`](https://www.filepicker.com/documentation/file_processing/image_conversion/crop?v=v2)
  an `filepicker_image_url`.

## 2.0.0 (July, 15, 2015)

- Properly-released version 1.5.0 and 1.5.1.
  This version uses the API V2 you can see more about the
  [migration here](https://www.filepicker.com/documentation/file_ingestion/javascript_api/migration?v=v2).
  Since dialog V2 was completely rebuilt from the ground up, custom css files
  from v1 will not work correctly with it.
  [See here](https://www.filepicker.com/documentation/file_ingestion/javascript_api/pick_multiple?v=v2#custom_css).

## 1.5.1 (July, 8, 2015) yanked due to mis-release

### bug fixes

- Update `filepicker_image_url` to merge query params into current url params if they exist

## 1.5.0 (June, 10, 2015) yanked due to mis-release

### features

- Update `filepicker_js_include_tag` to use the V2 api

### improvements

- Declare FilepickerRails::Tag as a private module

## 1.4.0 (May, 7, 2015)

:warning: :warning: :warning:
This is the last version that uses the
[API V1](https://www.filepicker.com/documentation/?v=v1).
:warning: :warning: :warning:

### features

- Add option for max number of files
- Add store_container option to filepicker_field
- Add open_to option to filepicker_field
- Add filepicker_field_tag helper method

### improvements

- Move from end-of-life multi_json to json

## 1.3.0 (December 31, 2014)

### features

- Adds filepicker_save_link

### improvements

- Adds support to Rails 4.2

## 1.2.0 (August 23, 2014)

### features

- filepicker_image_tag now works with policies

### improvements

- update to RSpec 3

### bug fixes

- Do not modify original url when using cdn

## 1.1.0 (March 30, 2014)

### features

- Add option to use a CDN
- Add option for max file size
- Add option to rotate image

### improvements

- Running specs on rails 3.2.x and 4.0
- Only append convert? when is needed

### misc

- Add license to gemspec
- Improved README with a bit more documentation for onchange callback

## 1.0.0 (September 20, 2013)

### features

### improvements

- Moved to a rails engine
- Add specs <3
- Add to Travis CI
- Create CHANGELOG
- Create CONTRIBUTING
- Add versioning, issue, contributing and credits sections on README
- Add rubygems badge
- Add codeclimate badge
- Add coveralls badge

### bug fixes

- Support rails 4

## Previous

The changelog began with version 1.0.0 so any changes prior to that
can be seen by checking the tagged releases and reading git commit
messages.
