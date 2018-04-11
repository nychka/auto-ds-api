require 'test_helper'

module Airflow
  class ListServiceTest < ActiveSupport::TestCase
    setup do
      @children = [{ job_name: 'wo_print_date1' }, { job_name: 'wo_print_date2' }]
    end

    test 'check if job exists' do
      mock_service('airflow/list')
      response = ListService.new(job_name: @job_name).call

      assert_equal({ data: @children, status: :ok }, response)
    end
  end
end