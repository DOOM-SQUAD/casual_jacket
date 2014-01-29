module CasualJacket

  module Packer

    extend self

    def cache_spreadsheet(handle, spreadsheet)
      spreadsheet.translated_rows do |index, attributes, group|
        cache_operation(handle, index, attributes, group)
      end
    end

    def cache_operation(handle, index, attributes, group)
      operation = Operation.new(index, attributes, group)
      redis_key = build_key(handle, operation)

      operation.to_hash.each do |key, value|
        set_hash_value(redis_key, key, value)
      end
    end

    def set_hash_value(redis_key, key, value)
      CasualJacket.redis_connection.hset(redis_key, key, value)
    end

    def build_key(handle, operation)
      "#{handle}-#{operation.id}"
    end

  end

end
