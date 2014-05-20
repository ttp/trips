Pohody::Application.routes.draw do

  post "users/ulogin" => "users#ulogin"
  get "users/edit-profile" => "users#edit_profile", as: :user_profile
  patch "users/edit-profile" => "users#update_profile"
  post "users/edit-profile" => "users#update_profile"

  get "trips" => "trips#index"
  get "trips/:id" => "trips#show", as: :trip
  post "trips/:id/join" => "trips#join"
  post "trips/:id/leave" => "trips#leave", as: :leave_trip
  post "trips/:id/approve/:user_id" => "trips#approve", as: :approve_trip_request
  post "trips/:id/decline/:user_id" => "trips#decline", as: :decline_trip_request

  get "trips/:trip_id/comments" => "trip_comments#index"
  post "trips/:trip_id/comments" => "trip_comments#create"
  patch "trips/:trip_id/comments/:comment_id" => "trip_comments#update"
  put "trips/:trip_id/comments/:comment_id" => "trip_comments#update"
  delete "trips/:trip_id/comments/:comment_id" => "trip_comments#destroy"

  get "calendar" => "calendar#index"

  namespace :menu do
    get "examples" => "menus#examples", as: :examples
    resources :menus do
      get 'products', on: :collection
    end
    resources :products do
      get 'category/:category', on: :collection, action: :category, as: :by_category
    end
  end

  get "about" => "home#about", as: :about
  post 'textile/preview' => 'textile#preview'

  root :to => "home#index"

  devise_for :users

  resources :users
  namespace :account do
    get 'trips/scheduled' => "trips#scheduled", as: :trips_scheduled
    get 'trips/archive' => "trips#archive", as: :trips_archive

    resources :tracks
    resources :trips
    get 'admin' => 'admin#index'
    get 'admin/switch_user' => 'admin#switch_user'
  end
end