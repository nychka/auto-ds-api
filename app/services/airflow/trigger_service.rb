module Airflow
  class TriggerService < BaseService
    attr_reader :job, :params

    def initialize(job, params = {})
      @job = job
      @params = params
      response[:status] = :ok
    end

    def call
      safe_call { provider.get(request_url).body }
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
