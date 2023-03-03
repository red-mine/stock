Rails.application.routes.draw do
  root  "stocks#index"
  get   "/stocks",                to: "stocks#index"
  get   "/staves",                to: "sotcks#stave"
  get   "/stocks/:stock/:years",  to: "stocks#show"
end
