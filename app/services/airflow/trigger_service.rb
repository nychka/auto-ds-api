module Airflow
  class TriggerService < BaseService
    attr_reader :job, :params

    def initialize(job, params = {})
      @job = job
      @params = params
    end

    def call
      handle { provider.get(request_url).body }
    end

    def handle
      response = yield

      case response['http_response_code']
      when 200
        job.processing!
      when 400..500
        job.error!
        fail response['output']
      end
      response
    end

    private

    def dag_id
      job.job_name
    end

    def run_id
      job.id
    end

    def execution_date
      params[:execution_date] || Date.yesterday.to_datetime
    end

    def configs
      { execution_date: execution_date }.to_json
    end

    def request_url
      request_params = { dag_id: dag_id, run_id: run_id, configs: configs }
      settings['api']['trigger_dag'] % request_params
    end
  end
end
