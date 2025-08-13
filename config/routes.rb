Rails.application.routes.draw do
  get 'cars/index'
  get 'cars/new'
  get 'cars/create'
  get 'cars/edit'
  get 'cars/update'
  get 'cars/destroy'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "cars#index"

  #definitions des routes une par une, sans refacto pour la pratique en utilisant resources
  get "cars/", to: "cars#index", as: "cars"
  get "cars/new", to: "cars#new", as: "new_car"
  get "cars/:id", to: "cars#show", as: "car"
  post "cars", to: "cars#create"
  get "cars/:id/edit", to: "cars#edit", as: "edit_car"
  patch "cars/:id", to: "cars#update"
  delete "cars/:id", to: "cars#destroy"

  get "cars/:car_id/maintenance_items/", to: "maintenance_items#index", as: "car_maintenance_items"
  get "cars/:car_id/maintenance_items/call_maintenance", to: "maintenance_items#call_maintenance", as: "car_maintenance_items_call_maintenance"
  get "cars/:car_id/maintenance_items/new", to: "maintenance_items#new", as: "new_car_maintenance_item"
  get "cars/:car_id/maintenance_items/:id", to: "maintenance_items#show", as: "car_maintenance_item"
  post "cars/:car_id/maintenance_items", to: "maintenance_items#create"
  get "cars/:car_id/maintenance_items/:id/edit", to: "maintenance_items#edit", as: "edit_car_maintenance_item"
  patch "cars/:car_id/maintenance_items/:id", to: "maintenance_items#update"
  delete "cars/:car_id/maintenance_items/:id", to: "maintenance_items#destroy"

  get "cars/:car_id/garage_stops/", to: "garage_stops#index", as: "car_garage_stops"
  get "cars/:car_id/garage_stops/new", to: "garage_stops#new", as: "new_car_garage_stop"
  get "cars/:car_id/garage_stops/picture_analysis", to: "garage_stops#picture_analysis", as: "new_car_garage_stop_picture_analysis"
  get "cars/:car_id/garage_stops/images_reading_request", to: "garage_stops#images_reading_request", as: "new_car_garage_stop_images_reading_request"
  get "cars/:car_id/garage_stops/:id", to: "garage_stops#show", as: "car_garage_stop"
  post "cars/:car_id/garage_stops", to: "garage_stops#create"
  get "cars/:car_id/garage_stops/:id/edit", to: "garage_stops#edit", as: "edit_car_garage_stop"
  patch "cars/:car_id/garage_stops/:id", to: "garage_stops#update"
  delete "cars/:car_id/garage_stops/:id", to: "garage_stops#destroy"

  get "cars/:car_id/garage_stops/:garage_stop_id/stop_items/", to: "stop_items#index", as: "car_garage_stop_stop_items"
  get "cars/:car_id/garage_stops/:garage_stop_id/stop_items/new", to: "stop_items#new", as: "new_car_garage_stop_stop_item"
  get "cars/:car_id/garage_stops/:garage_stop_id/stop_items/:id", to: "stop_items#show", as: "car_garage_stop_stop_item"
  post "cars/:car_id/garage_stops/:garage_stop_id/stop_items", to: "stop_items#create"
  get "cars/:car_id/garage_stops/:garage_stop_id/stop_items/:id/edit", to: "stop_items#edit", as: "edit_car_garage_stop_stop_item"
  patch "cars/:car_id/garage_stops/:garage_stop_id/stop_items/:id", to: "stop_items#update"
  delete "cars/:car_id/garage_stops/:garage_stop_id/stop_items/:id", to: "stop_items#destroy"

  get "garages/", to: "garages#index", as: "garages"
  get "garages/new", to: "garages#new", as: "new_garage"
  get "garages/:id", to: "garages#show", as: "garage"
  post "garages", to: "garages#create"
  get "garages/:id/edit", to: "garages#edit", as: "edit_garage"
  patch "garages/:id", to: "garages#update"
  delete "garages/:id", to: "garages#destroy"

end
