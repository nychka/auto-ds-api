class AirjobsController < ApplicationController
  # GET /airjobs
  def index
    jobs = Airjob.all

    render json: jobs, each_serializer: AirjobSerializer, with_children: true, status: :ok
  end

  # GET /airjobs/:id
  def show
    job = Airjob.find allowed_params[:id]
    
    render json: job, with_children: true, status: :ok
  end

  # POST /airjobs
  def create
    response = RunnerService.new(allowed_params).call

    render json: response.to_json, status: :created
  end

  # PUT /airjobs/:id
  def update
    response = UpdaterService.new(allowed_params).call

    render json: response, status: :ok
  end

  private

  def allowed_params
    params.permit(:id, :job_name, :status, :result)
  end
end
