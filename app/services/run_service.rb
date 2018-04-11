class RunService < Airflow::BaseService
  def initialize(params)
    @job_name = params[:job_name]
    @response = { data: nil, status: :created }
  end

  def call
    safe_call do
      list_response = Airflow::ListService.new(job_name: @job_name).call
      @job = Airjob.create!(job_name: @job_name, status: Airjob::PROCESSING)

      if list_response[:status] == :ok && list_response[:data].respond_to?(:each)
        list_response[:data].each do |child_job|
          child_job[:status] = Airjob::PROCESSING
          @job.children.create! child_job
        end
      end

      response = Airflow::TriggerService.new(job_name: @job.job_name, run_id: @job.id).call
      response[:data]
    end
  end
end
