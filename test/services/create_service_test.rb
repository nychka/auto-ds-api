require 'test_helper'

class CreateServiceTest < ActiveSupport::TestCase
  # call
  test 'status 200 when create job with valid data' do
    response = CreateService.new(job_name: 'test_service').call

    assert_equal({ data: Airjob.last, status: :created }, response)
  end

  test 'status 422 when create job with invalid data' do
    response = CreateService.new(job_name: '').call
    error_message = "Validation failed: Job name can't be blank, Job name is invalid"

    assert_equal({ data: error_message, status: :unprocessable_entity }, response)
  end
end
