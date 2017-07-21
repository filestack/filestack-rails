module FilestackRails
  class Engine < ::Rails::Engine
    config.filestack_rails = FilestackRails::Configuration.new
    isolate_namespace FilestackRails

    initializer 'filestack_rails.action_controller' do |app|
      ActiveSupport.on_load(:action_controller) do
        ::ActionController::Base.helper(FilestackRails::ApplicationHelper)
      end
    end

    initializer "filestack_rails.form_builder" do
      ActionView::Helpers::FormBuilder.send(:include, FilestackRails::FormHelper)
    end

  end
end
