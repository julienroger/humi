module Humi
  class Middleware::Authentication::Password < Humi::Middleware::Authentication
    def params
      {
        grant_type:    "password",
        client_id:     client.client_id,
        client_secret: client.client_secret,
        username:      client.username,
        password:      password
      }
    end

    def password
      "#{client.password}#{client.security_token}"
    end

    def auth_url
      "/oauth/token"
    end
  end
end
