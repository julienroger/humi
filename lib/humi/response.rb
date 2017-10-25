module Humi
  module Response
    def self.create(response_hash)
      data = response_hash.dup rescue response_hash
      data.extend(self)

      data.instance_exec do
        %w{pagination meta fields}.each do |k|
          response_hash.public_send(k).tap do |v|
            instance_variable_set("@#{k}", v) if v
          end
        end
      end

      data.instance_exec do
        %w{fields}.each do |k|
          next if response_hash.public_send(k).nil?

          response_hash.public_send(k).each do |key, value|
            instance_variable_set("@#{key}", value) if value
            singleton_class.class_eval { attr_reader key } if value
          end
        end
      end

      data
    end

    attr_reader :pagination
    attr_reader :meta
    attr_reader :fields
  end
end
