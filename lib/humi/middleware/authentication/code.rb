module Humi
  class Middleware::Authentication::Code < Humi::Middleware::Authentication
    def params
      {
        grant_type:    "authorization_code",
        code:          client.auth_code,
        client_id:     client.client_id,
        client_secret: client.client_secret
      }
    end

    def auth_url
      "/oauth/token"
    end
  end
end
