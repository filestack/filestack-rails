Rails.application.routes.draw do

  root to: 'welcome#index'
  mount FilepickerRails::Engine => "/filepicker_rails"
end
