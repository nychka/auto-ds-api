require 'test_helper'

class RunnerServiceTest < ActiveSupport::TestCase
  setup do
    @job_name = 'perform_upcase'

    mock_service('airflow/list')
    @trigger_response = mock_service('airflow/trigger')
    @response = RunnerService.new(job_name: @job_name).call
    @airjob = Airjob.find_by(job_name: @job_name)
  end

  test 'checks response' do
    assert_equal @trigger_response, @response
  end

  test 'creates airjob with two childs' do
    children_list = @airjob.children.pluck(:job_name)

    assert_equal %w(wo_print_date1 wo_print_date2), children_list
  end

  test 'transits from idle to processing' do
    assert @airjob.processing?
  end
end
