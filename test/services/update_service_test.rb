require 'test_helper'

class UpdateServiceTest < ActiveSupport::TestCase
  attr_reader   :airjob
  attr_accessor :params

  setup do
    @airjob = Airjob.create! job_name: 'hello'
    @params = airjob.attributes.symbolize_keys
  end

  test 'status 200 when updating job with valid data' do
    params[:status] = 'done'
    params[:result] = '/usr/bin/nowhere'
    response = UpdaterService.new(params).call

    assert_equal({ data: airjob.reload, status: :ok }, response)
  end

  test 'status 404 when could not find job by id' do
    params[:id] = 0
    response = UpdaterService.new(params).call
    error_message = "Couldn't find Airjob with 'id'=0"

    assert_equal({ data: error_message, status: :not_found }, response)
  end

  test 'status 422 when updating job with invalid data' do
    params[:status] = 'INVALID_STATUS'
    response = UpdaterService.new(@params).call
    error_message = "'INVALID_STATUS' is not a valid status"

    assert_equal({ data: error_message, status: :unprocessable_entity }, response)
  end
end
