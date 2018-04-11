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

    assert_response :ok, job.as_json
  end

  test 'show airjob with status 404' do
    get '/airjobs/0'

    assert_response :not_found
  end

  # POST /airjobs/:airflow_job
  test 'status 201' do
    mock_service('airflow/list')
    mock_service('airflow/trigger')

    post "/airjobs/#{@job_name}"

    assert_response :created, id: Airjob.last.id, name: 'test'
  end

  test 'status 422' do
    mock_service('airflow/list')

    post '/airjobs/!'

    assert_response :unprocessable_entity
  end

  test 'Response body' do
    mock_service('airflow/list')
    response = mock_service('airflow/trigger')

    post "/airjobs/#{@job_name}"

    assert_equal @response.body, { data: response, status: :created }.to_json
  end

  test 'Create new job' do
    assert_difference('Airjob.count', 3) do
      mock_service('airflow/list')
      mock_service('airflow/trigger')
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

  test 'status 404 when updating job' do
    put '/airjobs/0', params: { job_name: 'lost_job' }

    assert_response :not_found
  end
end
