module Humi
  class Middleware::Authentication < Humi::Middleware
    autoload :Token,    "humi/middleware/authentication/token"
    autoload :Code,     "humi/middleware/authentication/code"
    autoload :Password, "humi/middleware/authentication/password"

    def call(env)
      @app.call(env)
    rescue Humi::Unauthorized
      authenticate!
      raise
    end

    def authenticate!
      response = connection.post(auth_url) do |req|
        req.body = encode_www_form(params)
      end

      if response.status >= 500
        raise Humi::ServerError, error_message(response)
      elsif response.status != 200
        raise Humi::AuthenticationError, error_message(response)
      end

      client.access_token  = response.body.access_token
      client.refresh_token = response.body.refresh_token
      client.auth_callback.call(response.body) if client.auth_callback

      response.body
    end

    def params
      raise NotImplementedError
    end

    def auth_url
      raise NotImplementedError
    end

    def connection
      @connection ||= Faraday.new(faraday_options) do |connection|
        connection.use Faraday::Request::UrlEncoded
        connection.use FaradayMiddleware::Mashify
        connection.use Faraday::Response::ParseJson
        connection.response :json
        connection.use Humi::Middleware::Logger, Humi.logger, client if Humi.logger

        connection.adapter(Humi.adapter)
      end
    end

    def error_message(response)
      "#{response.body["error"]}: #{response.body["error_description"]}"
    end

    def encode_www_form(params)
      if URI.respond_to?(:encode_www_form)
        URI.encode_www_form(params)
      else
        params.map do |k, v|
          k = CGI.escape(k.to_s)
          v = CGI.escape(v.to_s)
          "#{k}=#{v}"
        end.join("&")
      end
    end

    private def faraday_options
      {
        url: client.endpoint,
        "headers" => {
          "User-Agent" => Humi.user_agent
        }
      }
    end
  end
end
