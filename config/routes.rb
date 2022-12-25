Rails.application.routes.draw do
  # get 'stocks/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get "/stocks", to: "stocks#index"

  # Defines the root path route ("/")
  root "stocks#index"
end
