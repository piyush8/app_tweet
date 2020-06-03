class Api::V1::SessionsController < Api::V1::ApiController
  skip_before_action :verify_authenticity_token
  skip_before_action :check_authenticate_user, only: [:get_area, :create, :vendor_city_area_name, :user_registration]

  def create
    if params['user'].present? && params['user']['email'].present?
	   user = User.find_by(email: params['user']['email'])
      if user && user.valid_password?(params['user']['password'])
        @auth_token = AuthToken.create(user_id: user.id, token: SecureRandom.hex(12))
        session_serializer = SessionSerializer.new(@auth_token)
        render json: {
          status: HTTP_OK[:code],
          message: "Login Successfully",
          data: session_serializer.serializable_hash[:data][:attributes]
        }
      else
        error_response_with_obj(HTTP_NOT_FOUND[:code], "Email and password does not match")
      end
    else
      error_response_with_obj(HTTP_BAD_REQUEST[:code], "Params missing")
    end
  end

  def logout
    if auth_token.present? && auth_token.destroy
      success_response_without_obj("Logout Successfully")
    else
      success_response_without_obj("Already Logout" )
    end
  end

  def user_registration
    if params['user'].present? && params['user']['email'].present?
    	user = User.find_by(email: params['user']['email'])
        if user.present?
          error_response_with_obj(HTTP_NOT_FOUND[:code], "Email ID Already register with us.")
        else
          user = User.new(user_params)
          user.save
          @auth_token = AuthToken.create(user_id: user.id, token: SecureRandom.hex(12))
          session_serializer = SessionSerializer.new(@auth_token)
            render json: {
              status: HTTP_OK[:code],
              message: "Register Successfully",
              data: session_serializer.serializable_hash[:data][:attributes]
          }
        end
    else
      error_response_with_obj(HTTP_BAD_REQUEST[:code], "Params missing")
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :is_admin)
  end

end
