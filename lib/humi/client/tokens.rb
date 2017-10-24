module Humi
  class Client
    module Tokens
      def create_token(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}

        post("api/v1/token", options)
      end
    end
  end
end
