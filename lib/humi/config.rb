require "logger"
require "faraday"
require "humi/version"

module Humi
  module Config
    VALID_CONFIG_KEYS = [
      :access_token,
      :auth_code,
      :username,
      :password,
      :auth_code,
      :refresh_token,
      :client_id,
      :client_secret,
      :auth_callback,
      :auth_retries,
      :adapter,
      :connection_options,
      :scope,
      :redirect_uri,
      :endpoint,
      :format,
      :user_agent,
      :logger
    ].freeze

    DEFAULT_ACCESS_TOKEN       = nil
    DEFAULT_AUTH_CODE          = nil
    DEFAULT_USERNAME           = nil
    DEFAULT_PASSWORD           = nil
    DEFAULT_REFRESH_TOKEN      = nil
    DEFAULT_CLIENT_ID          = nil
    DEFAULT_CLIENT_SECRET      = nil
    DEFAULT_AUTH_CALLBACK      = ->(response) {}
    DEFAULT_AUTH_RETRIES       = 3
    DEFAULT_ADAPTER            = Faraday.default_adapter
    DEFAULT_CONNECTION_OPTIONS = {}
    DEFAULT_SCOPE              = nil
    DEFAULT_REDIRECT_URI       = nil
    DEFAULT_ENDPOINT           = "https://www.humi.ca".freeze
    DEFAULT_FORMAT             = :json
    DEFAULT_USER_AGENT         = "Humi Ruby Client/#{Humi::VERSION}".freeze
    DEFAULT_LOGGER             = ::Logger.new(STDOUT)

    attr_accessor *VALID_CONFIG_KEYS

    def self.extended(base)
      base.reset
    end

    def configure
      yield self
    end

    def options
      VALID_CONFIG_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    def reset
      self.access_token       = DEFAULT_ACCESS_TOKEN
      self.auth_code          = DEFAULT_AUTH_CODE
      self.username           = DEFAULT_USERNAME
      self.password           = DEFAULT_PASSWORD
      self.refresh_token      = DEFAULT_REFRESH_TOKEN
      self.client_id          = DEFAULT_CLIENT_ID
      self.client_secret      = DEFAULT_CLIENT_SECRET
      self.auth_callback      = DEFAULT_AUTH_CALLBACK
      self.auth_retries       = DEFAULT_AUTH_RETRIES
      self.adapter            = DEFAULT_ADAPTER
      self.connection_options = DEFAULT_CONNECTION_OPTIONS
      self.scope              = DEFAULT_SCOPE
      self.redirect_uri       = DEFAULT_REDIRECT_URI
      self.endpoint           = DEFAULT_ENDPOINT
      self.format             = DEFAULT_FORMAT
      self.user_agent         = DEFAULT_USER_AGENT
      self.logger             = DEFAULT_LOGGER
    end
  end
end
