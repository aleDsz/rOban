# frozen_string_literal: true

class WorkerWithoutOptions < Oban::Worker
  def perform(job)
    puts 'Worker without options'
    job.args
  end
end
