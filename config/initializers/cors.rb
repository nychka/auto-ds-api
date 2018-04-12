Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "http://10.6.193.162/3000"
    resource '*',
      headers: :any,
      methods: %i(get post put patch delete options head)
  end
end
