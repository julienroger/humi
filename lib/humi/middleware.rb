module Humi
  class Middleware < Faraday::Middleware
    autoload :Authentication, "humi/middleware/authentication"
    autoload :Authorization,  "humi/middleware/authorization"
    autoload :Logger,         "humi/middleware/logger"

    def initialize(app, client, options)
      @app     = app
      @client  = client
      @options = options
    end

    def client
      @client
    end

    def connection
      client.send(:connection)
    end
  end
end
