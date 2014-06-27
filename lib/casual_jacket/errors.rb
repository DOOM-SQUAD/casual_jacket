module CasualJacket

  module Errors

    extend self

    def list(handle)
      Keys.connection.smembers(error_key(handle)).map do |error_json|
        CasualJacket::CachedError.from_redis(handle, error_json)
      end
    end

    def for_group(handle, group)
      list(handle).select { |cached_error| cached_error.group == group }
    end

    def add(handle, cached_error)
      Keys.connection.sadd(error_key(handle), cached_error.to_hash.to_json)
    end

    def clear(handle)
      Keys.connection.del(error_key(handle))
    end
    
    private

    def error_key(handle)
      Keys.errors(handle)
    end

  end

end
