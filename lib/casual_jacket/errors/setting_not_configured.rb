module CasualJacket

  module Errors

    class SettingNotConfigured < WardrobeMalfunction

      def initialize(method_name)
        super(" No values has been specified for \"#{method_name}\"")
      end

    end

  end

end
