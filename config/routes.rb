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

  get "cars/", to: "cars#index"
  get "cars/:id", to: "cars#show"
  get "cars/new", to: "cars#new"
  post "cars", to: "cars#create"
  get "cars/:id/edit", to: "cars#edit"
  patch "cars/:id", to: "cars#update"
  delete "cars/:id", to: "cars#destroy"

end
