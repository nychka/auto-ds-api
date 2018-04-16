require 'test_helper'

class RunServiceTest < ActiveSupport::TestCase
  setup do
    @job_name = 'perform_upcase'
    @job_children_list = ['wo_print_date1', 'wo_print_date2']
  end

  test 'runs job with two childs' do
    mock_service('airflow/list')
    trigger_response = mock_service('airflow/trigger')
    response = RunService.new(job_name: @job_name).call
    children_list = Airjob.find_by(job_name: @job_name).children.pluck(:job_name)

    assert_equal @job_children_list, children_list
    assert_equal trigger_response, response[:data]
  end
end
