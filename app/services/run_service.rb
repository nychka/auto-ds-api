class RunService < Airflow::BaseService
  attr_reader :airjob_params

  def initialize(airjob_params)
    @airjob_params = airjob_params
    response[:status] = :created
  end

  def call
    safe_call do
      airjob_children = check_airjob_children
      airjob = create(airjob_children)
      run(airjob)
    end
  end

  private

  def check_airjob_children
    resp = Airflow::ListService.new(airjob_params).call

    if (resp[:status] != :ok) || !resp[:data].respond_to?(:each)
      raise Faraday::ConnectionFailed.new(resp[:data])
    end

    resp[:data]
  end

  def create(airjob_children)
    resp = CreateService.new(airjob_params, airjob_children).call

    if (resp[:status] != :created)
      response[:status] = resp[:status]
      raise resp[:data]
    end

    resp[:data]
  end

  def run(airjob)
    resp = Airflow::TriggerService.new(airjob).call

    unless resp[:status] == :ok 
      raise Faraday::ConnectionFailed.new(resp[:data])
    end
    resp[:data]
  end
end