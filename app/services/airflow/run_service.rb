module Airflow
  class RunService < BaseService
    def initialize(params)
      super()
      @dag_id = params[:job_name]
      @task_id = params[:task_id]
      @execution_date = params[:execution_date] || Date.new(2017, 1, 1).to_datetime
    end

    def before_call
      @params = "/admin/rest_api/api?api=run&dag_id=#{@dag_id}&task_id=#{@task_id}&execution_date=#{@execution_date}"
    end

    def call
      safe_call { provider.get(@params).body }
    end
  end
end
