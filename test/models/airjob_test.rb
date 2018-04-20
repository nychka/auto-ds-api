require 'test_helper'

class AirjobTest < ActiveSupport::TestCase
  attr_reader :airjob

  setup do
    @airjob = Airjob.new
  end

  test 'is valid when has job_name' do
    airjob.job_name = 'foo'

    assert airjob.save
  end

  test 'is not valid when has invalid job_name' do
    airjob.job_name = '!'

    assert_not airjob.save
  end

  test 'is not valid without job_name' do
    assert_not airjob.save
  end

  test 'raises error when updates with invalid status' do
    airjob.job_name = 'test'
    airjob.save

    assert_raises ArgumentError do
      airjob.update status: 'not_valid_status'
    end
  end

  test 'is valid when status done and result not null' do
    airjob.job_name = 'foo'
    airjob.save

    assert airjob.update(status: 'done', result: 'file_path')
  end

  test 'is not valid when status done and result null' do
    airjob.save

    assert_not airjob.update(status: 'done')
  end
end
