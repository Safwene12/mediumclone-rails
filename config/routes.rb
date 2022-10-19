Rails.application.routes.draw do
  scope "api" do
    post "/users/login", to: "users#login"
    resource :users, only: [:create]
    resource :articles, only: [:create, :update]
  end
end
