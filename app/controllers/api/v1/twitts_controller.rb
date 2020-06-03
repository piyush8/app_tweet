class Api::V1::TwittsController < Api::V1::ApiController
	skip_before_action :verify_authenticity_token
  	
  	def create
		if params['twitt'].present? && params['twitt']['message'].present?
			twitt = current_user.twitts.create(twitt_params)
	        twitt_serializer = TwittSerializer.new(twitt)
			render json: {
			  status: HTTP_OK[:code],
			  message: "Twitt Created Successfully",
			  data: twitt_serializer.serializable_hash[:data][:attributes]
			}
		else
		error_response_with_obj(HTTP_BAD_REQUEST[:code], "Params missing")
		end
  	end


  	def destroy
  		twitt = Twitt.find_by id: params[:id]
  		if twitt.present?
  			if twitt.user_id == current_user.id || current_user.is_admin?
			    twitt.destroy
				render json: {
				  status: HTTP_OK[:code],
				  message: "Twitt Deleted Successfully"
				}
			else
				error_response_with_obj(HTTP_BAD_REQUEST[:code], "Twitt can delete by created user or admin.")
			end
		else
		error_response_with_obj(HTTP_BAD_REQUEST[:code], "Twitt not found.")
		end
  	end


  	def show
  		twitt = Twitt.find_by id: params[:id]
  		if twitt.present?
	        twitt_serializer = TwittSerializer.new(twitt)
			render json: {
			  status: HTTP_OK[:code],
			  data: twitt_serializer.serializable_hash[:data][:attributes]
			}
		else
		error_response_with_obj(HTTP_BAD_REQUEST[:code], "Twitt not found.")
		end
  	end

	def update
  		twitt = Twitt.find_by id: params[:id]
  		if twitt.present?
  			if twitt.user_id == current_user.id || current_user.is_admin?
			    twitt.update(twitt_params)
		        twitt_serializer = TwittSerializer.new(twitt)
				render json: {
				  status: HTTP_OK[:code],
				  data: twitt_serializer.serializable_hash[:data][:attributes]
				}
			else
				error_response_with_obj(HTTP_BAD_REQUEST[:code], "Twitt can delete by created user or admin.")
			end
		else
		error_response_with_obj(HTTP_BAD_REQUEST[:code], "Twitt not found.")
		end
  	end

  	def index
  		twitts = Twitt.all
        twitt_serializer = TwittSerializer.new(twitts)
		render json: {
		  status: HTTP_OK[:code],
		  data: twitt_serializer.serializable_hash[:data].map{ |data| data[:attributes]}
		}
  	end


  	private

  	def twitt_params
	    params.require(:twitt).permit(:message)
  	end
end
