require "faraday_middleware"
Dir[File.expand_path("../middleware/*.rb", __FILE__)].each{|f| require f}

module Humi
  module Connection
    private def connection(headers, raw = false)
      options = {
        :url     => endpoint,
        :headers => headers
      }.merge(connection_options)

      Faraday::Connection.new(options) do |connection|
        connection.use FaradayMiddleware::Mashify unless raw
        connection.request :json
        connection.use Middleware::Authorization, self, options
        connection.use Middleware::HttpException, self, options
        connection.use Middleware::Authentication, self, options
        connection.response :json, :content_type => /\bjson$/ unless raw
        connection.response :logger, logger if logger

        connection.adapter(adapter)
      end
    end
  end
end
