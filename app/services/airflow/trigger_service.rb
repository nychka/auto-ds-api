module Airflow
  class TriggerService < BaseService
    def initialize(job, params = {})
      super()
      @dag_id = job.job_name
      @run_id = job.id
      @execution_date = params[:execution_date] || Date.new(2017, 1, 1).to_datetime
    end

    def before_call
      run_conf_json = { execution_date: @execution_date }.to_json
      @params = "/admin/rest_api/api?api=trigger_dag&dag_id=#{@dag_id}}&run_id=#{@run_id}&conf=#{run_conf_json}"
    end

    def call
      safe_call { provider.get(@params).body }
    end
  end
end
