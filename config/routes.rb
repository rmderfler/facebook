Rails.application.routes.draw do
  # get 'profiles/show'

  

  # devise_for :users

  # devise_scope :user do 
  #   get 'register' => 'devise/registrations#new', as: :register
  #   get 'login' => 'devise/sessions#new', as: :login
  #   get 'logout' => 'devise/sessions#destroy', as: :logout
  # end

  # resources :user_friendships do 
  #   member do 
  #     put :accept
  #   end
  # end

  # resources :messages
  # get 'list' => 'messages#index', as: :list
  # root to: 'messages#index'

  # get '/:id', to: 'profiles#show', as: 'profile'
 
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
    end
  end

  resources :messages
  get 'list', to: 'messages#index', as: :list
  root to: 'messages#index'

  get '/:id', to: 'profiles#show', as: 'profile'
end
