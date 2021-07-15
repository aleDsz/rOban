# frozen_string_literal: true

class WorkerWithoutOptions
  include Oban::Worker

  def perform
    args
  end
end
