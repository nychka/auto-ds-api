require 'test_helper'

class AirjobTest < ActiveSupport::TestCase
  setup do
  end

  test 'is valid when has job_name and status' do
    assert airjobs(:valid).save
  end

  test 'is not valid without job_name' do
    assert_not airjobs(:not_valid_without_job_name).save
  end

  test 'is not valid without status' do
    assert_not airjobs(:not_valid_without_status).save
  end

  test 'is valid status when is included' do
    assert airjobs(:valid).save
  end

  test 'is not valid status when is included' do
    assert_not airjobs(:not_valid_status).save
  end

  test 'success? when status eql DONE' do
    job = airjobs(:status_done)

    assert job.success?
  end

  test 'success? when status not eql DONE' do
    job = airjobs(:not_valid_status)

    assert_not job.success?
  end

  test 'is valid with result when updating' do
    job = airjobs(:valid)
    job.save

    assert job.update(status: Airjob::DONE, result: 'file_path')
  end

  test 'is not valid with result null' do
    job = airjobs(:valid)
    job.save

    assert_not job.update(status: Airjob::DONE)
  end

  test 'is valid with result null and status not DONE' do
    job = airjobs(:valid)
    job.save

    assert job.update(status: Airjob::ERROR)
  end
end
