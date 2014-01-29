require 'json'
require 'redis'
require 'csv'

require_relative 'casual_jacket/errors/wardrobe_malfunction'
require_relative 'casual_jacket/errors/setting_not_configured'
require_relative 'casual_jacket/errors/invalid_group_header'

require_relative 'casual_jacket/config/options'
require_relative 'casual_jacket/config'
require_relative 'casual_jacket/config/option_definitions'

require_relative 'casual_jacket/spreadsheet'
require_relative 'casual_jacket/operation'
require_relative 'casual_jacket/packer'
require_relative 'casual_jacket/unpacker'

require_relative 'casual_jacket/version'

module CasualJacket

  extend self

  # Configure arbitrary options for CasualJacket.  Currently, the only
  # supported configuration change is the address of the cache's Redis
  # instance.
  #
  # Example:
  #
  #   CasualJacket.configure do |config|
  #     config.redis_host = 'your.redis_instance.biz:6379'
  #   end
  #   # => 'your.redis_instance.biz:6379'
  #
  # Returns the result of the block given or raises a WardrobeMalfunction
  # error.
  def configure(&block)
    yield Config if block_given?
  end

  # Load CasualJacke's configuration from a YAML file.
  #
  # Examples
  #
  #   CasualJacket.load!('config/casual_jacket.yml')
  #   # => { redis_host: 'your.redis_instance.biz:6379' }
  #
  # Returns configuration as a Hash.
  def load!(path)
    Config.load!(path)
  end

  # Process and store the information from an import CSV
  #
  # handle       - The String denoting the import's handle
  # file         - The CSV File/String to process
  # legend       - The Hash representing header mappings for the CSV
  # group_header - The String matching a spreadsheet header by which
  #                operations can be grouped
  #
  # Examples
  #
  #   handle = "test import"
  #   file   = "/tmp/products.csv"
  #   legend = {
  #     "headername" => "translation"
  #   }
  #   group_by = "Group Code"
  #
  #   CasualJacket.cache_operations(handle, file, legend, group_by)
  #   # => "OK"
  #
  # Returns the raw Redis response String once caching is completed, regardless
  # of state.
  def cache_operations(handle, file, legend, group_header)
    spreadsheet = Spreadsheet.new(file, legend, group_header)
    Packer.cache_spreadsheet(handle, spreadsheet)
  end

  # Thaw operations from the cache for a given handle.
  #
  # handle - The String denoting the operation group to retrieve.
  #
  # Examples
  #
  #   CasualJacket.operations_for("test_import")
  #   # => [ #<Operation:123>, #<Operation:456> ]
  #
  # Returns an Array of Operation objects
  def operations_for(handle)
    Unpacker.operations_for(handle)
  end

  # Return the current Redis connection.  While intended to be a utility method
  # for the rest of the library, this can be used to access the Redis store for
  # CasualJacket directly.
  #
  # Examples
  #
  #   CasualJacket.new.redis_connection
  #   # => #<Redis client v3.0.6 for redis://127.0.0.1:6379/0>
  #
  # Returns a Redis object representing CasualJacket's current Redis
  # connection.
  def redis_connection
    Redis.new(host: Config.redis_host)
  end

end

if defined?(Rails)
  require_relative 'casual_jacket/railtie'
end
