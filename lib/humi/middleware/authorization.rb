module Humi
  class Middleware::Authorization < Humi::Middleware
    AUTH_HEADER = "Authorization".freeze

    def call(env)
      env.request_headers[AUTH_HEADER] = %(Bearer #{token})
      @app.call(env)
    end

    def token
      client.access_token
    end
  end
end
