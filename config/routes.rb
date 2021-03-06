Rails.application.routes.draw do

  root "application#home"

  post "/log_in", to: "sessions#create"
  delete "/log_out", to: "sessions#destroy"

  get "/current_user", to: "users#current_user"
  get "/users/:id", to: "users#user"
  get "/messages", to: "messages#index"
  patch "/users/", to: "users#update"
  resources :users, only: [:create, :index]
  resources :posts, only: [:create, :index]
  resources :chat_rooms, only: [:create, :index, :show]

  mount ActionCable.server => '/cable'
end
