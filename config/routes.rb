Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :airjobs, only: [:update, :index, :show, :create]

  # TO DO DEVELOPMENT
  post 'test_airflow', to: 'development#test_airflow'
end
