module CasualJacket

  module Errors

    extend self

    def list(handle)
      Keys.connection.hgetall Keys.errors(handle)
    end

    def for_group(handle, group)
      Keys.connection.hget Keys.errors(handle), group
    end

    def add(handle, group, message)
      Keys.connection.hset Keys.errors(handle), group, message
    end

  end

end
