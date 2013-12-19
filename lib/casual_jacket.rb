require 'json'
require 'redis'
require 'csv'

require_relative 'casual_jacket/spreadsheet'
require_relative 'casual_jacket/operation'
require_relative 'casual_jacket/packer'
require_relative 'casual_jacket/unpacker'

module CasualJacket

  extend self

  def redis_connection
    Redis.new # FIXME
  end

  def cache(file, legend)
    spreadsheet = Spreadsheet.new(file, legend)
    Packer.new(spreadsheet).tap do |packer|
      # do all the things
    end
  end

end

if defined?(Rails)
  require_relative 'casual_jacket/railtie'
end
