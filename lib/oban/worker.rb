# frozen_string_literal: true

module Oban
  # Public: The Worker abstract class
  class Worker
    Job = Oban::Job

    def initialize(job)
      @job = job
    end

    private

    def params
      @job.args
    end
  end
end
