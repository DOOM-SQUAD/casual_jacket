require 'json'
require 'redis'
require 'csv'

require_relative 'casual_jacket/errors'
require_relative 'casual_jacket/errors/wardrobe_malfunction'
require_relative 'casual_jacket/errors/setting_not_configured'
require_relative 'casual_jacket/errors/invalid_group_header'

require_relative 'casual_jacket/config/options'
require_relative 'casual_jacket/config'
require_relative 'casual_jacket/config/option_definitions'

require_relative 'casual_jacket/keys'
require_relative 'casual_jacket/spreadsheet'
require_relative 'casual_jacket/operation'
require_relative 'casual_jacket/cached_error'
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
  #   group_header = "Group Code"
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

  # Iterate though the cached operations by group
  #
  # handle - The String denoting the import's handle
  # &block - The block receive the sets of operations
  #
  # Examples
  #
  #   handle = "test-import"
  #
  #   CasualJacket.each_operation_group(handle) do |operations|
  #     puts operations
  #   end
  #   # => { "group" => [ "test-import:operation:group:1234" ] }
  #
  # Returns the hash of groups and their child keys
  def each_operation_group(handle, &block)
    Keys.all(handle).each do |group, keys|
      operations = Unpacker.fetch_operations(keys)
      yield operations if block_given?
    end
  end

  # Thaw operations from the cache for a given handle.
  #
  # handle - The String denoting the handle to retrieve.
  # group  - The String denoting the operation group to retrieve.
  #
  # Examples
  #
  #   CasualJacket.operations_for("test_import", "foo")
  #   # => [ #<Operation:123>, #<Operation:456> ]
  #
  # Returns an Array of Operation objects
  def operation_group(handle, group)
    Unpacker.operation_group(handle, group)
  end

  # Returns the hashed versions of operations
  #
  # handle - The String for which handle to retrieve.
  #
  # Examples
  #
  #   CasualJacket.all_operations(handle)
  #   # => { "group" => [ #<Operation:123> ]
  #
  # Returns a hashed set of operation lists, organized by group
  def all_operations(handle)
    Unpacker.all_operations(handle)
  end

  # Fetch the set of CasualJacket::CachedError objects for the handle
  #
  # handle - The String for which handle to fetch errors
  #
  # Examples
  #
  #   CasualJacket.list_errors(handle)
  #   # => [ #<CasualJacket::CachedError:123> ]
  #
  # Returns an Array of CasualJacket::CachedError objects
  def list_errors(handle)
    Errors.list(handle)
  end

  # Purge all errors for a given handle from the cache
  #
  # handle - The String representing the error handle to purge
  #
  # Examples
  #
  #   CasualJacket.clear_errors(handle)
  #   # => nil
  #
  # Returns nil
  def clear_errors(handle)
    Errors.clear(handle)
  end

  # Fetch a set of errors for a given group.
  #
  # handle - The String representing the error handle
  # group  - The String representing the group to order by
  #
  # Examples
  #
  #   CasualJacket.errors_for_group(handle, group)
  #   # => [ #<CasualJacket::CachedError:123> ]
  #
  # Returns an Array of CasualJacket::CachedError objects
  def errors_for_group(handle, group)
    Errors.for_group(handle, group)
  end

  # Add an error to the cache
  #
  # handle       - The String representing the handle for the error
  # cached_error - The CasualJacket::CachedError object to be cached
  #
  # Examples
  #
  #   CasualJacket.add_error(handle, cached_error)
  #   # => nil
  #
  # Returns nil
  def add_error(handle, cached_error)
    Errors.add(handle, cached_error)
  end
end

if defined?(Rails)
  require_relative 'casual_jacket/railtie'
end
