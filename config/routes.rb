Rails.application.routes.draw do
  scope "api" do
    resources :users, only: [:create] do
      post "/login", to: "users#login", :on => :collection
    end
    post "/users/login", to: "users#login"
    get "/user", to: "users#current"
    put "/user", to: "users#update"
    get "/profiles/:username", to: "users#profile"

    resources :articles do
      get "/feed", to: "articles#feed", :on => :collection
      post "/:slug/favorite", to: "articles#favorite", :on => :collection
      delete "/:slug/favorite", to: "articles#unfavorite", :on => :collection
    end

    resources :tags, only: [:index]
  end
end
