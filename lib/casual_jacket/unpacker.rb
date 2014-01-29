module CasualJacket

  module Unpacker

    extend self

    def operations_for(handle)
      CasualJacket.redis_connection.keys("#{handle}*").map do |key|
        id = key.split('-').last
        Operation.from_redis(id, redis_hash(key))
      end
    end

    def failures_for(handle)
      operations_for(handle).select do |operation|
        error_ids_for(handle).include?(operation.id)
      end
    end

    private

    def redis_hash(key)
      CasualJacket.redis_connection.hgetall(key)
    end

    def error_key_for(handle)
      "errors:#{handle}"
    end

    def error_ids_for(handle)
      CasualJacket.redis_connection.get(error_key_for(handle))
    end

  end

end
