Rails.application.routes.draw do
  mount Stave::Engine => "/stave"

  root  "stocks#index"
  get   "/stocks/:years",         to: "stocks#index"

  get   "/stocks/:stock",         to: "stocks#show"
  get   "/stocks/:stock/:years",  to: "stocks#show"
end
