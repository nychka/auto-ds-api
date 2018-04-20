module Airflow
  class ListService < BaseService
    attr_reader :params, :dag_id

    def initialize(params)
      @params = params
      @dag_id = params[:job_name]
    end

    def call
      response = provider.get(request_url).body
      airjob_children = parse(response)
      structurize(airjob_children)
    end

    private

    def request_url
      settings['api']['list_tasks'] % { dag_id: dag_id }
    end

    def parse(response)
      case response['http_response_code']
      when 200
        response['output']['stdout'].scan settings['filename_pattern']
      when 400
        fail Faraday::ResourceNotFound, response['output']
      else
        fail response['output']
      end
    end

    def structurize(children)
      children.map { |child| { job_name: child } }
    end
  end
end
