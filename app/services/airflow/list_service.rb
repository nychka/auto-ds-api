module Airflow
  class ListService < BaseService
    def initialize(params)
      super()
      @dag_id = params[:job_name]
    end

    def before_call
      @params = "/admin/rest_api/api?api=list_tasks&dag_id=#{@dag_id}"
    end

    def call
      safe_call do
        provider.get(@params).body
      end
    end

    def after_call
      if @response[:data]['output'] && @response[:data]['output']['stdout']
        children = @response[:data]['output']['stdout'].scan /wo_[a-z0-9_]+/
        @response[:data] = children.map{ |job| { job_name: job } }
      end
    end
  end
end
