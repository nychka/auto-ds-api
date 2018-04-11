class UpdateService < Airflow::BaseService
  def initialize(id, params)
    @id = id
    params.delete :id
    @params = params
    @response = { data: nil, status: :ok }
  end

  def call
    safe_call do
      job = Airjob.find @id
      job.update! @params
      job
    end
  end
end
