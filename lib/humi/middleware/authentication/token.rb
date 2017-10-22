module Humi
  class Middleware::Authentication::Token < Humi::Middleware::Authentication
    def params
      {
        grant_type:    "refresh_token",
        refresh_token: client.refresh_token,
        client_id:     client.client_id,
        client_secret: client.client_secret
      }
    end

    def auth_url
      "/oauth/token"
    end
  end
end
