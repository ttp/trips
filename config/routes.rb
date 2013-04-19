Pohody::Application.routes.draw do

  get "trips" => "trips#index"
  get "trips/:id" => "trips#show", as: :trip
  post "trips/:id/join" => "trips#join"
  post "trips/:id/leave" => "trips#leave", as: :leave_trip
  post "trips/:id/approve/:user_id" => "trips#approve", as: :approve_trip_request
  post "trips/:id/decline/:user_id" => "trips#decline", as: :decline_trip_request

  get "trips/:trip_id/comments" => "trip_comments#index"
  post "trips/:trip_id/comments" => "trip_comments#create"
  put "trips/:trip_id/comments/:comment_id" => "trip_comments#update"
  delete "trips/:trip_id/comments/:comment_id" => "trip_comments#destroy"

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"

  devise_for :users

  resources :users
  namespace :account do
    resources :tracks
    resources :trips
  end
end