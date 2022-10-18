class UsersController < ApplicationController
  skip_before_action :authorized
  #REGISTER
  def create
    puts "*********************************"
    puts user_params[:user]
    @user = User.create(user_params[:user])
    if (@user.valid? && @user.save)
      token = encode_token({ user_id: @user.id })
      @user.token = token
      # methods to add the additional attribut 'token' to the api response else it will return only the db object
      render json: { user: @user }, methods: [:token]
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  # LOGGING IN
  def login
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])
      token = encode_token({ user_id: @user.id })
      @user.token = token
      # methods to add the additional attribut 'token' to the api response else it will return only the db object
      render json: { user: @user }, methods: [:token]
    else
      render json: { error: "Invalid username or password" }
    end
  end

  private

  def user_params
    params.permit(user: [:username, :password, :email])
  end
end
