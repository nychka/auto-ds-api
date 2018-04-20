module Airflow
  class BaseService
    def call
      fail 'You have to implement call method!'
    end

    def provider
      Faraday.new(url: settings['host']) do |faraday|
        faraday.response :logger, ::Logger.new(STDOUT), bodies: true
        faraday.response :json
        faraday.adapter Faraday.default_adapter
      end
    end

    def settings
      Settings['airflow']
    end
  end
end
