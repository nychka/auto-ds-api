require 'test_helper'

module Airflow
  class ListServiceTest < ActiveSupport::TestCase
    setup do
      @parent = { job_name: 'wo_parent' }
      @children = [{ job_name: 'wo_print_date1' }, { job_name: 'wo_print_date2' }]
    end

    test 'gets list airjob children' do
      mock_service('airflow/list')
      response = ListService.new(@parent).call

      assert_equal(@children, response)
    end

    test 'raises ConnectionFailed' do
      error_message = 'connection failed'
      provider_mock = mock('object')
      provider_mock.expects(:get).raises(Faraday::ConnectionFailed.new(error_message))
      ListService.any_instance.stubs(:provider).returns(provider_mock)

      err = assert_raises Faraday::ConnectionFailed do
        ListService.new(@parent).call
      end

      assert_equal error_message, err.message
    end

    test 'raises ResourceNotFound' do
      response = fixture_json('airflow/list')
      response['http_response_code'] = 400
      response['output'] = "The DAG ID '#{@parent[:job_name]}' does not exist"
      provider_mock = response_mock = mock('object')
      response_mock.expects(:body).returns(response)
      provider_mock.expects(:get).returns(response_mock)
      ListService.any_instance.stubs(:provider).returns(provider_mock)

      err = assert_raises Faraday::ResourceNotFound do
        ListService.new(@parent).call
      end

      assert_equal response['output'], err.message
    end
  end
end
