module FilepickerRails
  # @private
  class Engine < ::Rails::Engine
    config.filepicker_rails = FilepickerRails::Configuration.new
    isolate_namespace FilepickerRails

    initializer "filepicker_rails.form_builder" do
      ActionView::Helpers::FormBuilder.send(:include, FilepickerRails::FormHelper)
    end

    initializer 'filepicker_rails.action_controller' do |app|
      ActiveSupport.on_load(:action_controller) do
        ::ActionController::Base.helper(FilepickerRails::ApplicationHelper)
      end
    end
  end
end
