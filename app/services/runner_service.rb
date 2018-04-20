class RunnerService < Airflow::BaseService
  attr_reader :airjob_params

  def initialize(airjob_params)
    @airjob_params = airjob_params
  end

  def call
    airjob_children = Airflow::ListService.new(airjob_params).call
    airjob = CreatorService.new(airjob_params, airjob_children).call
    Airflow::TriggerService.new(airjob).call
  end
end
