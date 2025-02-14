class UsersController < ApplicationController
	def register
    user = User.new(user_params)
    if user.save
      render json: UserSerializer.new(user).serializable_hash, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end


 def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = generate_jwt(user.id)
	    render json: { token: token, user: UserSerializer.new(user).serializable_hash }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

	private

  def user_params
    params.permit(:name, :email, :password, :phone, :status)
  end

  def generate_jwt(user_id)
    payload = { user_id: user_id, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, Rails.application.secret_key_base)
  end
end
