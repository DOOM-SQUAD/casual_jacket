module CasualJacket

  module Config

    module Options

      extend self

      def reset
        settings.replace(defaults)
      end

      def defaults
        @defaults ||= {}
      end

      def settings
        @settings ||= {}
      end

      def raise_not_configured(method_name)
        raise Errors::SettingNotConfigured.new(method_name)
      end

      def option(name, options={})
        defaults[name] = settings[name] = options[:default]

        class_eval <<-RUBY
          def #{name}
            settings[#{name.inspect}] || raise_not_configured(#{name.inspect})
          end

          def #{name}=(value)
            settings[#{name.inspect}] = value
          end

          def #{name}?
            !!settings[#{name.inspect}]
          end
        RUBY
      end

    end

  end

end
