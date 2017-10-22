require "humi/connection"
require "humi/request"
require "humi/authentication"

module Humi
  class API
    attr_accessor *Config::VALID_CONFIG_KEYS

    def initialize(options = {})
      options = Humi.options.merge(options)

      Config::VALID_CONFIG_KEYS.each do |key|
        send("#{key}=", options[key])
      end

      @logger ||= Humi.logger
    end

    def config
      conf = {}

      Config::VALID_CONFIG_KEYS.each do |key|
        conf[key] = send key
      end

      conf
    end

    include Connection
    include Request
    include Authentication
  end
end
