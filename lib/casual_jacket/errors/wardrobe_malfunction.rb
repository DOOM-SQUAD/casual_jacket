module CasualJacket

  module Errors

    class WardrobeMalfunction < StandardError

      def initialize(message)
        super(message)
      end

    end

  end

end
