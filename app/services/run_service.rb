class RunService < Airflow::BaseService

  def initialize(params)
    @job_name = params[:job_name]
    @response = { data: nil, status: :created }
  end

  def check
    response = Airflow::ListService.new(job_name: @job_name).call

    if (response[:status] != :ok) || !response[:data].respond_to?(:each)
      raise Faraday::ConnectionFailed.new(response[:data])
    end

    response[:data]
  end

  def create(children)
    response = CreateService.new({ job_name: @job_name }, children).call

    if (response[:status] != :created)
      @response[:status] = response[:status]
      raise response[:data]
    end

    response[:data]
  end

  def run(job)
    response = Airflow::TriggerService.new(job).call

    unless response[:status] == :ok 
      raise Faraday::ConnectionFailed.new(response[:data])
    end
    response[:data]
  end

  def call
    safe_call do
      children = check
      job = create(children)
      run(job)
    end
  end
end