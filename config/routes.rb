Rails.application.routes.draw do
  devise_for :users
  resources :messages
  root to: 'messages#index'
 

end
