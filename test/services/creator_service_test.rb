require 'test_helper'

class CreatorServiceTest < ActiveSupport::TestCase
  test 'creates record' do
    response = CreatorService.new(job_name: 'test_service').call

    assert_equal Airjob.last, response
  end

  test 'creates job with children' do
    children = [{ job_name: 'child-1' }, { job_name: 'child-2' }]

    assert_difference 'Airjob.count', 3 do
      CreatorService.new({ job_name: 'parent' }, children).call
    end
  end

  test 'raises RecordInvalid when create job with invalid data' do
    error = assert_raises ActiveRecord::RecordInvalid do
      CreatorService.new(job_name: '').call
    end
    error_message = "Validation failed: Job name can't be blank, Job name is invalid"

    assert_equal error_message, error.message
  end
end
