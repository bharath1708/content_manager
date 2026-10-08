Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "contents", to: "contents#index"
      post "contents", to: "contents#create"
      get "contents/:id", to: "contents#show"
      patch "contents/:id", to: "contents#update"
      delete "contents/:id", to: "contents#destroy"
      # Category routes
      get "categories", to: "categories#index"
      post "categories", to: "categories#create"
      get "categories/:id", to: "categories#show"
      patch "categories/:id", to: "categories#update"
      delete "categories/:id", to: "categories#destroy"
    end
  end
end
