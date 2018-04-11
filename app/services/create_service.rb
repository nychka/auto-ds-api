class CreateService < Airflow::BaseService
  def initialize(params)
    @job_name = params[:job_name]
    @status = params[:status] || Airjob::PROCESSING
    @params = { job_name: @job_name, status: @status }
    @response = { data: nil, status: :created }
  end

  def call
    safe_call { Airjob.create! @params }
  end
end
