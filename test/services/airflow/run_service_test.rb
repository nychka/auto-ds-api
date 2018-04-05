require 'test_helper'

module Airflow
  class RunServiceTest < ActiveSupport::TestCase
    setup do
      @job_name = 'perform_upcase'
      @execution_date = Date.new(2017, 1, 1).to_datetime
      @task_id = "#{@job_name}_task"
      @params = { job_name: @job_name, execution_date: @execution_date, task_id: @task_id }
    end

    test 'status 200 when run job' do
      data = fixture_json('airflow/run')
      provider_mock = response_mock = mock('object')
      provider_mock.expects(:get).returns(response_mock)
      response_mock.expects(:body).returns(data)
      RunService.any_instance.stubs(:provider).returns(provider_mock)
      response = RunService.new(@params).call

      assert_equal(data, response[:data])
      assert_equal :ok, response[:status]
    end

    test 'status 500 when server is not responding' do
      mock = mock('object')
      mock.expects(:get).raises(Faraday::ConnectionFailed.new('ooops'))
      RunService.any_instance.stubs(:provider).returns(mock)
      response = RunService.new(@params).call

      assert_equal :service_unavailable, response[:status]
    end
  end
end
