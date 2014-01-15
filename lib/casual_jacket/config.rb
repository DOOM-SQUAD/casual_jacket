module CasualJacket

  module Config

    extend self
    extend Options

    def load!(path)
      options = load_yaml(path) if settings
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
