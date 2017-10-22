require "faraday"
require "faraday_middleware"
require "json"

require "pry"

require "humi/version"
require "humi/config"
require "humi/middleware"
require "humi/api"
require "humi/client"
require "humi/response"

module Humi
  extend Config

  def self.new(options = {})
    Humi::Client.new(options)
  end

  def self.client(options = {})
    Humi::Client.new(options)
  end

  def self.method_missing(method, *args, &block)
    return super unless client.respond_to?(method)
    client.send(method, *args, &block)
  end

  def self.respond_to?(method, include_all = false)
    return client.respond_to?(method, include_all) || super
  end

  Error               = Class.new(StandardError)
  ServerError         = Class.new(Error)
  APIVersionError     = Class.new(Error)
  AuthenticationError = Class.new(Error)
  Unauthorized        = Class.new(Error)
  BadRequest          = Class.new(Error)
  NotFound            = Class.new(Error)
  Unprocessable       = Class.new(Error)
  TooManyRequests     = Class.new(Error)
  BadGateway          = Class.new(Error)
  ServiceUnavailable  = Class.new(Error)
  GatewayTimeout      = Class.new(Error)
end
