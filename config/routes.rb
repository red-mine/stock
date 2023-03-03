Rails.application.routes.draw do
  root  "stocks#index"
  get   "/stocks/:years",         to: "stocks#index"
  get   "/stocks/:stock/:years",  to: "stocks#show"
end
