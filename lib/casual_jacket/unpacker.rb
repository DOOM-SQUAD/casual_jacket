module CasualJacket

  class Unpacker

    attr_reader :handle, :operations

    def initialize(handle)
      @handle = handle
      refresh_operations
    end

    def refresh_operations
      @operations = fetch_operations
    end

    def failed_operations
      operations.select do |operation|
        error_ids.include?(operation.id)
      end
    end

    private

    def fetch_operations
      CasualJacket.redis_connection.keys("#{handle}*").map do |key|
        id = key.split('-').last
        Operation.from_json(id, operation_json(key))
      end
    end

    def operation_json(key)
      CasualJacket.redis_connection.get(key)
    end

    def error_key
      "errors:#{handle}"
    end

    def error_ids
      CasualJacket.redis_connection.get(error_key)
    end

  end

end
