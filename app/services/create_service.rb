class CreateService < Airflow::BaseService
  attr_reader :params, :children

  def initialize(params, children = [])
    job_name = params[:job_name]
    status = params[:status] || Airjob::PROCESSING
    @params = { job_name: job_name, status: status }
    @children = children
    @response = { data: nil, status: :created }
  end

  def call
    safe_call do 
    	job = Airjob.new params

    	if children.any?
    		children.each do |child|
    			child[:status] = Airjob::PROCESSING
    			job.children.build child
    		end
    	end
    	job.save!
    	job
    end
  end
end
