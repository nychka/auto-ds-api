class AirjobsController < ApplicationController
  def index
    jobs = Airjob.all

    render json: jobs, status: :ok
  end

  def show
    if job = Airjob.find_by(id: allowed_params[:id])
      render json: job, status: :ok
    else
      render json: { error: "Could not find job with id #{allowed_params[:id]}"}, status: :not_found
    end
  end

  # POST /airjobs/:airflow_job
  def init
    @job = Airjob.new
    @job.job_name = allowed_params[:airflow_job]
    @job.status = Airjob::PROCESSING

    if @job.save
      render json: @job, status: 201
    else
      render json: { error: 'Uprocessable entity' }, status: 422
    end
  end
  # PUT /airjobs/:job_id
  def update
    @job = Airjob.find allowed_params[:id]

    if @job.update status: allowed_params[:status], result: allowed_params[:result]
      render json: { job: @job }, status: 200
    else
      render json: { error: 'Uprocessable entity' }, status: 422
    end
  end

  private

  def allowed_params
    params.permit(:airflow_job, :id, :status, :result)
  end
end
