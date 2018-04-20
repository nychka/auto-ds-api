class UpdaterService < Airflow::BaseService
  attr_accessor :params

  def initialize(params)
    @params = params
  end

  def handle
      job = Airjob.find params[:id]
      params.delete :id
      job.update! params
      job
  end
end