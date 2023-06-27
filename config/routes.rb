Rails.application.routes.draw do
  root 'pages#home'
  get 'oauth2/twitter'
  get 'oauth2_config/twitter'
  post "/graphql", to: "graphql#execute"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
