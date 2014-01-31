module CasualJacket

  module Packer

    extend self

    def cache_spreadsheet(handle, spreadsheet)
      spreadsheet.translated_rows do |index, attributes, group|
        cache_operation(handle, index, attributes, group)
      end

      write_groups
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

    def write_groups(spreadsheet)
      CasualJacket.redis_connection.set(
        group_list_key, spreadsheet.group_list
      )
    end

    def group_list_key
      "#{handle}-groups"
    end

  end

end
