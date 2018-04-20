require 'test_helper'

module Airflow
  class TriggerServiceTest < ActiveSupport::TestCase
    attr_reader :airjob, :params

    setup do
      @execution_date = Date.new(2017, 1, 1).to_datetime
      @airjob = Airjob.create({ job_name: 'perform_upcase' })
      @params = { execution_date: @execution_date }
    end

    test 'gets status 200 when trigger remote job' do
      data = fixture_json('airflow/trigger')
      provider_mock = response_mock = mock('object')
      response_mock.expects(:body).returns(data)
      provider_mock.expects(:get).returns(response_mock)
      TriggerService.any_instance.stubs(:provider).returns(provider_mock)
      response = TriggerService.new(airjob, params).call

      assert_equal(data, response)
    end

    test 'raises ConnectionFailed' do
      error_message = 'ooops'
      mock = mock('object')
      mock.expects(:get).raises(Faraday::ConnectionFailed.new(error_message))
      TriggerService.any_instance.stubs(:provider).returns(mock)

      err = assert_raises Faraday::ConnectionFailed do
        response = TriggerService.new(airjob, params).call
      end

      assert_equal error_message, err.message
    end
  end
end
