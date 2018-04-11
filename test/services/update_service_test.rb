require 'test_helper'

class UpdateServiceTest < ActiveSupport::TestCase
  setup do
    @job = Airjob.create! job_name: 'hello', status: Airjob::PROCESSING
  end

  test 'status 200 when updating job with valid data' do
    response = UpdateService.new(@job.id, status: Airjob::DONE, result: '/usr/bin/nowhere').call

    assert_equal({ data: @job.reload, status: :ok }, response)
  end

  test 'status 404 when could not find job by id' do
    response = UpdateService.new(0, job_name: 'lost_job').call
    error_message = "Couldn't find Airjob with 'id'=0"

    assert_equal({ data: error_message, status: :not_found }, response)
  end

  test 'status 422 when updating job with invalid data' do
    response = UpdateService.new(@job.id, status: 'INVALID_STATUS').call
    error_message = 'Validation failed: Status is not included in the list'

    assert_equal({ data: error_message, status: :unprocessable_entity }, response)
  end
end
