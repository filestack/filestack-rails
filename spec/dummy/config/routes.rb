Rails.application.routes.draw do
  resources :users
  root 'users#index'
  mount FilestackRails::Engine => "/filestack_rails"
end
