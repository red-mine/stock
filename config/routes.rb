Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "stocks#index"
  get "/stocks", to: "stocks#index"
  get "/stocks/:stock", to: "stocks#show"
end
