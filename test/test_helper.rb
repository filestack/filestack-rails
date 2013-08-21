require 'rubygems'
require 'bundler/setup'

Bundler.require

require 'minitest/autorun'
require 'ostruct'

require 'rails'
require 'active_model'
require 'action_view'
require 'action_view/template'
require 'action_view/test_case'

$:.unshift File.expand_path("../../lib", __FILE__)
require 'filepicker-rails'

Dir["#{File.dirname(__FILE__)}/support/*.rb"].each do |file|
  require file
end

ActionView::Helpers::FormBuilder.send(:include, Filepicker::Rails::FormBuilder)
ActionView::Base.send(:include, Filepicker::Rails::ViewHelpers)

class ActionView::TestCase
  def with_concat_form_for(*args, &block)
    concat form_for(*args, &block)
  end

  def protect_against_forgery?
    false
  end

  def user_path(*args)
    '/users'
  end

  alias :users_path :user_path
end

module Rails
  def self.application
    OpenStruct.new(
      :config => OpenStruct.new(
        :filepicker_rails => OpenStruct.new(:api_key => "")
      ),
      :env_config => {}
    )
  end
end