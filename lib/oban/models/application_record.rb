# frozen_string_literal: true

# Public: Base Model
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
