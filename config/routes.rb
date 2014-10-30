Rails.application.routes.draw do
  
  resources :activities, only: [:index]

as :user do
    get '/register', to: 'devise/registrations#new',via: :get, as: :register
    get '/login', to: 'devise/sessions#new', via: :get, as: :login
    get '/logout', to: 'devise/sessions#destroy', via: :delete, as: :logout
  end

  devise_for :users, :skip => [:sessions]

  as :user do
    get '/login' => 'devise/sessions#new', as: :new_user_session
    post '/login' => 'devise/sessions#create', as: :user_session
    delete '/logout' => 'devise/sessions#destroy', as: :destroy_user_session
  end

  resources :user_friendships do
    member do
      put :accept
      put :block
    end
  end

  resources :messages
  get 'list', to: 'messages#index', as: :list
  root to: 'messages#index'

  get '/:id', to: 'profiles#show', as: 'profile'
end
