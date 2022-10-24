class UsersController < ApplicationController
  skip_before_action :authorized, except: [:current, :update]
  #REGISTER
  def create
    @user = User.create(user_params[:user])
    if (@user.valid? && @user.save)
      render json: { user: serializer.new(@user) }, status: :ok
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  # LOGGING IN
  def login
    @user = User.find_by(email: params[:user][:email])

    if @user && @user.authenticate(params[:user][:password])
      render json: { user: serializer.new(@user) }, status: :ok
    else
      render json: { errors: { credentials: ["Invalid username or password"] } }, status: :unauthorized
    end
  end

  def current
    render json: { user: serializer.new(@user) }, status: :ok
  end

  def profile
    user = User.find_by_username(params[:username])
    if !user
      return render json: { error: { user: ["not found"] } }, status: :not_found
    end
    render json: { profile: ProfileSerializer.new(user) }, status: :ok
  end

  def update
    @user.update(profile_params[:user])

    if (@user.save)
      render json: { user: serializer.new(@user) }, status: :ok
    else
      render json: { error: @user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(user: [:username, :password, :email])
  end

  def profile_params
    params.permit(user: [:bio, :email, :password, :image, :username])
  end

  def serializer
    UserSerializer
  end
end
