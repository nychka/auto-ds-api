class ApplicationController < ActionController::API
	rescue_from ApiError, with: :error_handler

	def error_handler(e)
	  render json: e.message, status: e.status
	end
end
