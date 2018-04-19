class RecordInvalid < ApiError
	attr_reader :object, :status

	def initialize(object)
		@object = object
		@status = :unprocessable_entity
	end

	def message
		object.message
	end
end