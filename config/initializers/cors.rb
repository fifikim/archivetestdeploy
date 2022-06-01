Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://143.198.229.107'
    resource '*', headers: :any, methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end