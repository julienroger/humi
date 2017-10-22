module Humi
  class Middleware::HttpException < Humi::Middleware
    def call(env)
      @app.call(env).on_complete do |response|
        case response.status
        when 400
          raise Humi::BadRequest, error_message(response)
        when 401
          raise Humi::Unauthorized, error_message(response)
        when 403
          raise Humi::Forbidden, error_message(response)
        when 404
          raise Humi::NotFound, error_message(response)
        when 422
          raise Humi::Unprocessable, error_message(response)
        when 429
          raise Humi::TooManyRequests, error_message(response)
        when 500
          message = "Something went wrong on the server."
          raise Humi::ServerError, error_message(response, message)
        when 502
          message = "The server returned an invalid or incomplete response."
          raise Humi::BadGateway, error_message(response, message)
        when 503
          message = "Humi is rate limiting your requests."
          raise Humi::ServiceUnavailable, error_message(response, message)
        when 504
          message = "504 Gateway time-out."
          raise Humi::GatewayTimeout, error_message(response, message)
        end
      end
    end

    private def error_message(response, message = nil)
      method_name = response.method.to_s.upcase
      url         = response.url.to_s
      status      = response.status.to_s
      message   ||= response.body.to_s

      "#{method_name} #{url}: #{status} #{message}"
    end
  end
end
