class ApplicationController < ActionController::API
	rescue_from StandardError, with: :error_handler

	def error_handler(e)
	  render json: { error: e.message }.to_json, status: error_status(e)
	end

	private

	def error_status(e)
		error_status_map[e.class.name] || Settings['errors']['http_statuses']['default']
	end

	def error_status_map
		Settings['errors']['http_statuses']
	end
end
