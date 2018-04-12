class RunService < Airflow::BaseService
  def initialize(params)
    @job_name = params[:job_name]
    @response = { data: nil, status: :created }
  end

  def check
    response = Airflow::ListService.new(job_name: @job_name).call

    if (response[:status] != :ok) || !response[:data].respond_to?(:each)
      throw new Faraday::ConnectionFailed(response[:data])
    end

    response[:data]
  end

  def create(jobs)
    job = Airjob.create!(job_name: @job_name, status: Airjob::PROCESSING)

    jobs.each do |child_job|
      child_job[:status] = Airjob::PROCESSING
      job.children.create! child_job
    end
    job
  end

  def run(job)
    response = Airflow::TriggerService.new(job_name: job.job_name, run_id: job.id).call

    unless response[:status] == :ok 
      throw new Faraday::ConnectionFailed(response[:data])
    end
    response[:data]
  end

  def call
    safe_call { run(create(check)) }
  end
end
