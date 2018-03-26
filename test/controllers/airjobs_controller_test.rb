require 'test_helper'

class AirjobsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @job_name = 'test_job'
  end

  # GET /airjobs
  test 'GET list of airjobs' do
    get '/airjobs'

    assert_response :ok
  end

  # GET /airjobs/:id
  test 'show airjob with status 200' do
    job = airjobs(:valid)
    job.save

    get "/airjobs/#{job.id}"

    assert_response :ok, job
  end

  test 'show airjob with status 404' do
    get '/airjobs/0'

    assert_response :not_found
  end

  # POST /airjobs/:airflow_job
  test 'status 201' do
    post "/airjobs/#{@job_name}"

    assert_response :created, id: Airjob.last.id, name: 'test'
  end

  test 'status 422' do
    post '/airjobs/!'

    assert_response :unprocessable_entity
  end

  test 'Response body' do
    post "/airjobs/#{@job_name}"
    body = Airjob.last.to_json

    assert_equal @response.body, body
  end

  test 'Create new job' do
    assert_difference('Airjob.count') do
      post "/airjobs/#{@job_name}"
    end
  end

  # PUT /airjobs/:id
  test 'status 200' do
    job = Airjob.create job_name: @job_name, status: Airjob::PROCESSING
    put "/airjobs/#{job.id}", params: { status: Airjob::DONE, result: '/file/path' }

    assert_response :ok
  end

  test 'status 422 when updating status without result' do
    job = Airjob.create job_name: @job_name, status: Airjob::PROCESSING
    put "/airjobs/#{job.id}", params: { status: Airjob::DONE }

    assert_response :unprocessable_entity
  end
end
