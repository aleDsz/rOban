# frozen_string_literal: true

class WorkerWithoutOptions < Oban::Worker
  def perform(_job)
    puts 'Worker without options'
    params
  end
end
