Rails.application.routes.draw do
  get 'home/index'
  devise_for :admins
  devise_for :users
  scope "(:locale)", locale: /ja|en/ do
    get "tasks/index" => "tasks#index"
    resources :tasks#, format: false

    resources :users, :only => [:index, :edit, :update], format: false
  end

  namespace :api do
    resources :tasks#, only: [:index, :show, :create]
  end

  root to: "tasks#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
