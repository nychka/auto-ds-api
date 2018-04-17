module Airflow
  class BaseService
    attr_accessor :response

    ERRORS_MAP = { Faraday::ConnectionFailed => :service_unavailable,
                   ActiveRecord::RecordNotFound => :not_found,
                   ActiveRecord::RecordInvalid => :unprocessable_entity,
                   ArgumentError => :unprocessable_entity
                 }.freeze

    def response
      @response ||= { data: nil, status: :ok }
    end

    def before_call; end
    def after_call; end

    def provider
      Faraday.new(url: settings['host']) do |faraday|
        faraday.response :logger, ::Logger.new(STDOUT), bodies: true
        faraday.adapter Faraday.default_adapter
      end
    end

    def settings
      Settings['airflow']
    end

    def safe_call
      begin
        before_call
        response[:data] = yield
        after_call
      rescue *ERRORS_MAP.keys => e
        response[:data] = e.message
        response[:status] = ERRORS_MAP[e.class]
      rescue RuntimeError
      end
      response
    end
  end
end
