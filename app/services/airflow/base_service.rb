module Airflow
  class BaseService
    attr_reader :response

    def initialize
      @host = 'http://localhost:8080'
      @response = { data: nil, status: :ok }
    end

    def before_call; end
    def after_call; end

    def provider
      Faraday.new(url: @host) do |faraday|
        faraday.response :logger, ::Logger.new(STDOUT), bodies: true
        faraday.adapter Faraday.default_adapter
      end
    end

    def safe_call
      begin
        before_call
        @response[:data] = yield
        after_call
      rescue Faraday::ConnectionFailed => e
        @response[:data] = e.message
        @response[:status] = :service_unavailable
      rescue ActiveRecord::RecordNotFound => e
        @response[:data] = e.message
        @response[:status] = :not_found
      rescue ActiveRecord::RecordInvalid => e
        @response[:data] = e.message
        @response[:status] = :unprocessable_entity
      end
      @response
    end
  end
end
