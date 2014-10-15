Rails.application.routes.draw do
  get 'profiles/show'

  devise_for :users

  devise_scope :user do 
    get 'register' => 'devise/registrations#new', as: :register
    get 'login' => 'devise/sessions#new', as: :login
    get 'logout' => 'devise/sessions#destroy', as: :logout
  end

  resources :messages
  get 'list' => 'messages#index', as: :list
  root to: 'messages#index'
 

end
