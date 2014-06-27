module CasualJacket

  class CachedError

    attr_reader :handle, :context, :group, :operation_id

    def self.from_redis(handle, json_string)
      error_hash = JSON.parse(json_string)
      new(handle, error_hash['context'], error_hash['group'], error_hash['operation_id'])
    end

    def initialize(handle, context, group=nil, operation_id=nil)
      @handle       = handle
      @context      = JSON.parse(context)
      @group        = group
      @operation_id = operation_id
    end

    def operation
      if group && operation_id
        Unpacker.single_operation(operation_key)
      end
    end

    def operation_group
      Unpacker.operation_group(handle, group)
    end

    def to_hash
      {
        'context'      => context.to_json,
        'group'        => group,
        'operation_id' => operation_id
      }
    end

    private

    def operation_key
      Keys.operation(handle, group, operation_id)
    end

  end

end
