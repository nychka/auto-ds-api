module Airflow
  class ListService < BaseService
    attr_reader :params, :dag_id, :airjob_name_pattern
    attr_accessor :request_url

    def initialize(params)
      @params = params
      @airjob_name_pattern = /wo_[a-z0-9_]+/
      @dag_id = params[:job_name]
    end

    def before_call
      request_url = "/admin/rest_api/api?api=list_tasks&dag_id=#{dag_id}"
    end

    def call
      safe_call { provider.get(request_url).body }
    end

    def after_call
      airjob_children = output.scan airjob_name_pattern
      response[:data] = airjob_children.map{ |child| { job_name: child } }
    end

    private

    def output
      raise 'Check response structure!' unless response[:data]['output'] && response[:data]['output']['stdout']
      response[:data]['output']['stdout']
    end
  end
end
