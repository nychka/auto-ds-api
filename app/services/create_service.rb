class CreateService
  def initialize(params)
    @job_name = params[:job_name]
    @status = params[:status] || Airjob::PROCESSING
    @params = { job_name: @job_name, status: @status }
    @response = { data: nil, status: :created }
  end

  def call
    begin
      @response[:data] = Airjob.create! @params
    rescue ActiveRecord::RecordInvalid => e
      @response[:data] = e.message
      @response[:status] = :unprocessable_entity
    end
    @response
  end
end