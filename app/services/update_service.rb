class UpdateService
  def initialize(id, params)
    @id = id
    params.delete :id
    @params = params
    @response = { data: nil, status: :ok }
  end

  def call
    begin
      job = Airjob.find @id
      job.update! @params
      @response[:data] = job
    rescue ActiveRecord::RecordNotFound => e
      @response[:data] = e.message
      @response[:status] = :not_found
    rescue ActiveRecord::RecordInvalid => e
      @response[:data] = e.message
      @response[:status] = :unprocessable_entity
    end
    @response
  end
end