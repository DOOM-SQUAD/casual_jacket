require 'casual_jacket'

module CasualJacket

  class Railtie < Rails::Railtie

    def self.generator
      config.respond_to?(:app_generators) ? :app_generators : :generators
    end

    def handle_configuration_error(error)
      puts "There is a configuration error with casual_jacket.yml"
      puts error.message
    end

    config.bean_counter = ::CasualJacket::Config

    initializer "casual_jacket.configure" do
      config_file = Rails.root.join('config', 'casual_jacket.yml')

      if config_file.file?
        ::CasualJacket.load!(config_file)
      end
    end

  end

end
