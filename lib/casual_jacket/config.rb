module CasualJacket

  module Config

    extend self
    extend Options

    def load!(path, environment=nil)
      compiled_config = ERB.new(File.read(path)).result
      self.options = YAML.load(compiled_config) if settings
    end

    def options=(options)
      if options
        options.each_pair do |option, value|
          public_send("#{option}=", value)
        end
      end
    end

  end

end
