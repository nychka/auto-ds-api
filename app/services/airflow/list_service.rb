module Airflow
  class ListService < BaseService
    attr_reader :params, :dag_id

    def initialize(params)
      @params = params
      @dag_id = params[:job_name]
    end

    def call
      safe_call { provider.get(request_url).body }
    end

    def after_call
      airjob_children = output.scan settings['filename_pattern']
      response[:data] = airjob_children.map{ |child| { job_name: child } }
    end

    private

    def output
      raise 'Check response structure!' unless response[:data]['output'] && response[:data]['output']['stdout']
      
      response[:data]['output']['stdout']
    end

    def request_url
      settings['api']['list_tasks'] % { dag_id: dag_id }
    end
  end
end
