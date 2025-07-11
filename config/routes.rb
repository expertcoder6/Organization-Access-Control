Rails.application.routes.draw do
  resources :contents
  root "home#index"
  get 'home/index'
  
  devise_for :users

  resources :organizations do
    post :add_user, on: :member
  end

  post 'confirm_child/:id', to: 'home#confirm', as: :confirm_child
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
end
