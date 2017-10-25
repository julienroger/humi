module Humi
  module Request
    def get(path, options = {})
      request(:get, path, get_delete_headers, options)
    end

    def post(path, options = {})
      request(:post, path, post_put_headers, options)
    end

    def put(path, options = {})
      request(:put, path, post_put_headers, options)
    end

    def delete(path, options = {})
      request(:delete, path, get_delete_headers, options)
    end

    private def request(method, path, headers, options)
      begin
        response = connection(headers).send(method) do |request|
          case method
          when :get, :delete
            request.url(URI.encode(path), options)
          when :post, :put
            request.path = URI.encode(path)
            request.body = options unless options.empty?
          end
        end

        return Response.create(response.body)

      rescue Humi::Unauthorized
        if retries > 0
          retries -= 1
          retry
        end
        raise
      end
    end

    private def get_delete_headers
      {
        "Accept"     => "application/#{format}; charset=utf-8",
        "User-Agent" => user_agent
      }
    end

    private def post_put_headers
      get_delete_headers.merge({
        "Content-Type" => "application/#{format}; charset=utf-8"
      })
    end
  end
end
