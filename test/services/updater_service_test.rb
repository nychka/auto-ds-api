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

    assert_equal airjob.reload, response
  end

  test 'raises RecordNotFound when could not find job by id' do
    params[:id] = 0
    error = assert_raises ActiveRecord::RecordNotFound do
      UpdaterService.new(params).call
    end
    error_message = "Couldn't find Airjob with 'id'=0"

    assert_equal error_message, error.message
  end

  test 'raises RecordInvalid when updating job with invalid data' do
    params[:status] = 'INVALID_STATUS'
    error = assert_raises ArgumentError do
      UpdaterService.new(@params).call
    end
    error_message = "'INVALID_STATUS' is not a valid status"

    assert_equal error_message, error.message
  end
end
