Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :airjobs, only: [:update, :index, :show]
  post 'airjobs/:airflow_job', to: 'airjobs#init'

  # TO DO DEVELOPMENT
  post 'test_airflow', to: 'development#test_airflow'
end
