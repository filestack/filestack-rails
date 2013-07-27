require 'rails/railtie'

module Filepicker
  module Rails
    class Railtie < ::Rails::Railtie

      config.filepicker_rails = Filepicker::Rails::Configuration.new

      initializer "filepicker_rails.view_helpers" do
        ActionView::Base.send(:include, Filepicker::Rails::ViewHelpers)
      end

      initializer "filepicker_rails.form_builder" do
        ActionView::Helpers::FormBuilder.send(:include, Filepicker::Rails::FormBuilder)
      end
    end

  end
end
