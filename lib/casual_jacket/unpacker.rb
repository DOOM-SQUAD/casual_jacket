module CasualJacket

  module Unpacker

    extend self

    def single_operation(key)
      Operation.from_redis redis_hash(key)
    end

    def operation_group(handle, group)
      fetch_operations Keys.for_group(handle, group)
    end

    def all_operations(handle)
      Keys.all(handle).inject({}) do |operations, (group, keys)|
        operations.tap { |ops| ops[group] = fetch_operations(keys) }
      end
    end

    def failures_for(handle)
      error_keys(handle).map do |key|
        Operation.from_redis redis_hash(key)
      end
    end

    def fetch_operations(keys)
      fetch_keys(keys).map { |hash| Operation.from_redis(hash) }
    end

    private

    def error_keys(handle)
      Keys.errors_list(handle)
    end

    def fetch_keys(keys)
      keys.map { |key| redis_hash(key) }
    end

    def redis_hash(key)
      Keys.connection.hgetall(key)
    end

  end

end
