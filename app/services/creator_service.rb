class CreatorService < Airflow::BaseService
  attr_reader :children, :airjob, :params

  def initialize(params, children = [])
    @params = params
    @children = children
    response[:status] = :created
  end

  def call
    safe_call do 
    	build_children if children.any?
    	airjob.save!
    	airjob
    end
  end

  private 

  def airjob
  	@airjob ||= Airjob.new params
  end

  def build_children
  	children.each { |child| airjob.children.build child }
  end
end
