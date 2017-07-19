Rails.application.routes.draw do
  resources :users
  get 'hello/index'
  post 'hello/save'
  root 'hello#index'
  mount FilestackRails::Engine => "/filestack_rails"
end
