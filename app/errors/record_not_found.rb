class RecordNotFound < ApiError
	attr_reader :object, :status

	def initialize(object)
		@object = object
		@status = :not_found
	end

	def message
		object.message
	end
end