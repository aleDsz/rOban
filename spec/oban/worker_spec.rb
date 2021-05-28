# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Oban::Worker, type: :worker do
  context 'without options' do
    it 'instantiates a custom worker' do
      job = Job.new({ args: { id: 123 } })
      worker = WorkerWithoutOptions.new(job)

      expect(worker.is_a?(described_class)).to be true
    end

    it 'performs the worker with created job' do
      args = { id: 123 }
      job = Oban::Job.create({ args: args })
      worker = WorkerWithoutOptions.new(job)

      result = worker.perform(job)
      expected_result = args.stringify_keys!

      expect(result).to eq(expected_result)
    end
  end
end
