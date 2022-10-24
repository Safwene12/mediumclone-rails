class ApplicationController < ActionController::API
  before_action :authorized

  #Generate a secret key by rails secret keys
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

  #Action to convert the user payload to token
  def encode_token(payload)
    payload[:exp] = 24.hours.from_now.to_i
    # in production the secret key should be an ENV variable.
    JWT.encode(payload, SECRET_KEY)
  end

  #Here we get the header with the key authorization
  def auth_header
    request.headers["Authorization"]
  end

  # here we decrypt the user token
  def decoded_token
    if auth_header
      token = auth_header.split(" ")[1]
      begin
        JWT.decode(token, SECRET_KEY, true, algotithm: "HS256")
      rescue JWT::DecodeError
        nil
      end
    end
  end

  #Here we get the logged user from the token
  def logged_in_user
    if decoded_token
      user_id = decoded_token[0]["user_id"]
      @user = User.find_by(id: user_id)
    end
  end

  #Check if user is logged
  #True if variable is initialized
  def logged_in?
    !!logged_in_user
  end

  #returns a message asking user to log in unless if logged_in return true
  def authorized
    render json: { message: "You are not loggedIn" }, status: :unauthorized unless logged_in?
  end

  def current
    logged_in_user
  end
end
