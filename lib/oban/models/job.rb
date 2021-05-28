# frozen_string_literal: true

module Oban
  # Public: The Job model.
  class Job < ApplicationRecord
    self.table_name = 'oban_jobs'

    validates :worker, presence: true
  end
end
