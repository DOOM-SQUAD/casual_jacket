module CasualJacket

  module Keys

    OPERATION_NAMESPACE = 'operation'
    GROUPS_NAMESPACE    = 'groups'
    ERROR_NAMESPACE     = 'errors'

    extend self

    def connection
      @connection ||= Redis.new(url: Config.redis_host)
    end

    def base_operation(handle)
      "#{handle}#{Config.separator}#{OPERATION_NAMESPACE}"
    end

    def grouped_operation(handle, group)
      "#{base_operation(handle)}#{Config.separator}#{group}"
    end

    def operation(handle, group, id)
      "#{grouped_operation(handle, group)}#{Config.separator}#{id}"
    end

    def errors(handle)
      "#{handle}#{Config.separator}#{ERROR_NAMESPACE}"
    end

    def all(handle)
      all_for_handle(handle).group_by do |key|
        key.split(Config.separator)[2]
      end
    end

    def for_group(handle, group)
      connection.keys("#{grouped_operation(handle, group)}*")
    end

    private

    def all_for_handle(handle)
      connection.keys("#{base_operation(handle)}*")
    end

  end

end
