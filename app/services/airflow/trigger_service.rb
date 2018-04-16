module Airflow
  class TriggerService < BaseService
    attr_reader :job, :params, :request_url

    def initialize(job, params = {})
      @job = job
      @params = params
      response[:status] = :ok
    end

    def before_call
      request_url = "/admin/rest_api/api?api=trigger_dag&dag_id=#{dag_id}}&run_id=#{run_id}&conf=#{settings}"
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
      params[:execution_date] || Date.new(2017, 1, 1).to_datetime
    end

    def settings
      { execution_date: execution_date }.to_json
    end
  end
end
