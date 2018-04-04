module Airflow
  class RunService
    def initialize(params)
      @dag_id = params[:job_name]
      @task_id = params[:task_id]
      @response = { data: nil, status: :ok }
      @execution_date = params[:execution_date] || Date.new(2017,1,1).to_datetime
      @params = "/admin/rest_api/api?api=run&dag_id=#{@dag_id}&task_id=#{@task_id}&execution_date=#{@execution_date}"
    end

    def call
      begin
        response = provider.get @params
        @response[:data] = response.body
      rescue Faraday::ConnectionFailed => e
        @response[:data] = e.message
        @response[:status] = :service_unavailable
      end
      @response
    end

    def provider
      Faraday.new(url: 'http://localhost:8080') do |faraday|
        faraday.response :json
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end