module CasualJacket

  module Packer

    extend self

    def cache_spreadsheet(handle, spreadsheet)
      spreadsheet.translated_rows do |attributes, index|
        cache_operation(handle, attributes, index)
      end
    end

    def cache_operation(handle, attributes, index)
      operation = Operation.new(index, attributes)

      CasualJacket.redis_connection.set(
        build_key(handle, operation),
        operation.to_json
      )
    end

    def build_key(handle, operation)
      "#{handle}-#{operation.id}"
    end

  end

end
