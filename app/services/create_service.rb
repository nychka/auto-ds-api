class CreateService < Airflow::BaseService
  attr_reader :children, :job

  def initialize(params, children = [])
    @params = params
    @children = children
    response[:status] = :created
  end

  def call
    safe_call do 
    	build_children if children.any?
    	job.save!
    	job
    end
  end

  private 

  def params
    status = @params[:status] || Airjob::PROCESSING
    { job_name: @params[:job_name], status: status }
  end

  def job
  	@job ||= Airjob.new params
  end

  def build_children
  	children.each do |child|
  		child[:status] = Airjob::PROCESSING
  		job.children.build child
  	end
  end
end
