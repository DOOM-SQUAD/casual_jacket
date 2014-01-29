module CasualJacket

  module Errors

    class InvalidGroupHeader < WardrobeMalfunction

      def initialize(group_by)
        super("The given group \"#{group_by}\" does not exist in the given headers")
      end

    end

  end

end
