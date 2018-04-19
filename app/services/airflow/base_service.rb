module Airflow
  class BaseService
    def handle
      raise 'You have to implement handle method!'
    end

    def call
      begin
        handle
      rescue Faraday::ConnectionFailed => e
        raise ::ConnectionFailed.new(e)
      rescue ActiveRecord::RecordNotFound => e
        raise ::RecordNotFound.new(e)
      rescue ActiveRecord::RecordInvalid, ArgumentError => e
        raise ::RecordInvalid.new(e)
      end
    end

    def provider
      Faraday.new(url: settings['host']) do |faraday|
        faraday.response :logger, ::Logger.new(STDOUT), bodies: true
        faraday.adapter Faraday.default_adapter
      end
    end

    def settings
      Settings['airflow']
    end
  end
end
