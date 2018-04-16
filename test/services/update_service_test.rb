require 'test_helper'

class UpdateServiceTest < ActiveSupport::TestCase
  setup do
    @job = Airjob.create! job_name: 'hello', status: Airjob::PROCESSING
    @params = @job.attributes.symbolize_keys
  end

  test 'status 200 when updating job with valid data' do
    @params[:status] = Airjob::DONE
    @params[:result] = '/usr/bin/nowhere'
    response = UpdateService.new(@params).call

    assert_equal({ data: @job.reload, status: :ok }, response)
  end

  test 'status 404 when could not find job by id' do
    @params[:id] = 0
    response = UpdateService.new(@params).call
    error_message = "Couldn't find Airjob with 'id'=0"

    assert_equal({ data: error_message, status: :not_found }, response)
  end

  test 'status 422 when updating job with invalid data' do
    @params[:status] = 'INVALID_STATUS'
    response = UpdateService.new(@params).call
    error_message = 'Validation failed: Status is not included in the list'

    assert_equal({ data: error_message, status: :unprocessable_entity }, response)
  end
end
