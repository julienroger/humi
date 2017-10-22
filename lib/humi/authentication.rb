module Humi
  module Authentication
    def authenticate!
      unless authentication_middleware
        raise AuthenticationError, "No authentication middleware present"
      end

      middleware = authentication_middleware.new nil, self, {}
      middleware.authenticate!
    end

    def authentication_middleware
      if username_password?
        Humi::Middleware::Authentication::Password
      elsif oauth_refresh?
        Humi::Middleware::Authentication::Token
      elsif auth_code?
        Humi::Middleware::Authentication::Code
      end
    end

    def username_password?
      [
        :username,
        :password,
        :client_id,
        :client_secret
      ].all? { |k| !!send(k) }
    end

    def oauth_refresh?
      [
        :refresh_token,
        :client_id,
        :client_secret
      ].all? { |k| !!send(k) }
    end

    def auth_code?
      [
        :auth_code,
        :client_id,
        :client_secret
      ].all? { |k| !!send(k) }
    end
  end
end
