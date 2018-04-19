class ResourceNotFound < ApiError
	attr_reader :message, :status

	def initialize(message)
		@message = message
		@status = :not_found
	end
end