# frozen_string_literal: true

require 'active_record'
require_relative 'oban/version'

# Public: Oban main module
module Oban
  PATHS = [
    '/models/*.rb',
    '/*.rb'
  ].freeze

  def self.start
    PATHS.each { |path| require_files(path) }
  end

  def self.root
    File.expand_path './oban/', __dir__
  end

  def self.require_files(path)
    path = File.join(root, path)
    Dir[path].sort.each { |file| require file }
  end
end

Oban.start
