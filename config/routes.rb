Rails.application.routes.draw do
  scope "api" do
    resource :users, only: [:create]
    post "/users/login", to: "users#login"
  end
end
