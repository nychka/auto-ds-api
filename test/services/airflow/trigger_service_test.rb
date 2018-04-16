require 'test_helper'

module Airflow
  class TriggerServiceTest < ActiveSupport::TestCase
    attr_reader :airjob, :params

    setup do
      @execution_date = Date.new(2017, 1, 1).to_datetime
      @airjob = Airjob.create({ job_name: 'perform_upcase' })
      @params = { execution_date: @execution_date }
    end

    test 'status 200 when run job' do
      data = fixture_json('airflow/trigger')
      provider_mock = response_mock = mock('object')
      provider_mock.expects(:get).returns(response_mock)
      response_mock.expects(:body).returns(data)
      TriggerService.any_instance.stubs(:provider).returns(provider_mock)
      response = TriggerService.new(airjob, params).call

      assert_equal(data, response[:data])
      assert_equal :ok, response[:status]
    end

    test 'status 500 when server is not responding' do
      mock = mock('object')
      mock.expects(:get).raises(Faraday::ConnectionFailed.new('ooops'))
      TriggerService.any_instance.stubs(:provider).returns(mock)
      response = TriggerService.new(airjob, params).call

      assert_equal :service_unavailable, response[:status]
    end
  end
end
