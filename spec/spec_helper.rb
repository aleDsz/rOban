# frozen_string_literal: true

require 'oban'
require 'erb'

# Start ActiveRecord database connection
GEM_ROOT = File.expand_path '..', __dir__
CONFIG_PATH = File.join(GEM_ROOT, 'db/config.yml')
CONFIG = YAML.safe_load(
  ERB.new(File.read(CONFIG_PATH)).result,
  aliases: true
)

ActiveRecord::Base.establish_connection(CONFIG['test'])

# Load fixtures
FIXTURES_ROOT = File.expand_path 'fixtures', __dir__
FIXTURES_FILES = File.join(FIXTURES_ROOT, '*.rb')

Dir[FIXTURES_FILES]
  .sort
  .each { |file| require file }

# Configures RSpec
RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!
  config.mock_with :rspec
  config.order = 'random'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
