module CasualJacket

  module Unpacker

    extend self

    def operations_for(handle)
      CasualJacket.redis_connection.keys("#{handle}*").map do |key|
        id = key.split('-').last
        Operation.from_json(id, operation_json(key))
      end
    end

    def failures_for(handle)
      operations_for(handle).select do |operation|
        error_ids_for(handle).include?(operation.id)
      end
    end

    private

    def operation_json(key)
      CasualJacket.redis_connection.get(key)
    end

    def error_key_for(handle)
      "errors:#{handle}"
    end

    def error_ids_for(handle)
      CasualJacket.redis_connection.get(error_key_for(handle))
    end

  end

end
