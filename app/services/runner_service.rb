class RunnerService < Airflow::BaseService
  attr_reader :airjob_params

  def initialize(airjob_params)
    @airjob_params = airjob_params
  end

  def handle
    airjob_children = check_airjob_children
    airjob = create(airjob_children)
    run(airjob)
  end

  private

  def check_airjob_children
    Airflow::ListService.new(airjob_params).call
  end

  def create(airjob_children)
    CreatorService.new(airjob_params, airjob_children).call
  end

  def run(airjob)
    Airflow::TriggerService.new(airjob).call
  end
end