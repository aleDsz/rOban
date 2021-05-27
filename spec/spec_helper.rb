# frozen_string_literal: true

require 'oban'

GEM_ROOT = File.expand_path '..', __dir__
CONFIG_PATH = File.join(GEM_ROOT, 'db/config.yml')
CONFIG = YAML.safe_load(File.open(CONFIG_PATH), aliases: true)

ActiveRecord::Base.establish_connection(CONFIG['test'])

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!
  config.mock_with :rspec
  config.order = 'random'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
