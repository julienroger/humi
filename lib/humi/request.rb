module Humi
  module Request
    def get(path, options = {}, **args)
      request(:get, path, options, args)
    end

    def post(path, options = {}, **args)
      request(:post, path, options, args)
    end

    def put(path, options = {}, **args)
      request(:put, path, options, args)
    end

    def delete(path, options = {}, **args)
      request(:delete, path, options, args)
    end

    private def request(method, path, options, args)
      raw     = args.fetch(:raw, false)
      retries = args.fetch(retries, auth_retries)

      begin

        response = connection(raw).send(method) do |request|

          path = formatted_path(path) unless args.fetch(:unformatted, true)

          case method
          when :get, :delete
            request.url(URI.encode(path), options)
          when :post, :put
            request.path = URI.encode(path)
            request.body = options unless options.empty?
          end
        end

        return response      if raw
        return response.body if args.fetch(:no_response_wrapper, false)
        return Response.create(response.body)

      rescue Humi::Unauthorized
        if retries > 0
          retries -= 1
          retry
        end
        raise
      end
    end

    private def formatted_path(path)
      [path, format].compact.join(".")
    end
  end
end
