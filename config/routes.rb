Rails.application.routes.draw do
  scope "api" do
    resources :users, only: [:create]
    post "/users/login", to: "users#login"
    get "/user", to: "users#current"
    put "/user", to: "users#update"
    get "/profiles/:username", to: "users#profile"

    resources :articles

    resources :tags, only: [:index]
  end
end
