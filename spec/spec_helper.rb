# Set gem root directory
ROOT = File.expand_path(File.join('..', '..'), __FILE__)

# Require spec support files
Dir[File.join(ROOT, 'spec', 'support', '**', '*.rb')].each { |file| require file }

# Set load path for the gem itself
$LOAD_PATH.unshift(File.expand_path(ROOT))

require 'casual_jacket'
require 'pry'

RSpec.configure do |config|
  config.mock_with :rspec
end
