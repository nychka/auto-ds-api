class ApplicationController < ActionController::API
	rescue_from ApiError, with: :error_handler

	def error_handler(e)
	  render json: { error: e.message, status: e.status }.to_json, status: e.status
	end
end
