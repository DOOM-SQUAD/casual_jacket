module CasualJacket

  module Packer

    extend self

    def cache_spreadsheet(handle, spreadsheet)
      spreadsheet.each_translated_row do |index, attributes, group|
        operation = Operation.new(index, attributes, group)
        cache_operation(handle, operation)
      end
    end

    def cache_operation(handle, operation)
      redis_key = Keys.operation(handle, operation.group, operation.id)

      operation.to_hash.each do |key, value|
        set_hash_value(redis_key, key, value)
      end
    end

    private

    def set_hash_value(redis_key, key, value)
      Keys.connection.hset(redis_key, key, value)
    end

  end

end
