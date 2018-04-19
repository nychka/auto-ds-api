class ConnectionFailed < ApiError
	attr_reader :object, :status

	def initialize(object)
		@object = object
		@status = :service_unavailable
	end

	def message
		object.message
	end
end
