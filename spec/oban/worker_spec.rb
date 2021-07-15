# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Oban::Worker, type: :worker do
  let(:args) { { id: 123 } }

  context 'without options' do
    let(:worker) { WorkerWithoutOptions }

    context 'from custom worker' do
      it 'inserts job with correctly fields' do
        job = worker.perform_async(args)
        expected_args = args.stringify_keys!

        expect(job.args).to eq(expected_args)
        expect(job.worker).to eq('WorkerWithoutOptions')
        expect(job.state).to eq('available')
      end

      it 'performs the worker with created job' do
        job = worker.perform_async(args)

        result = described_class.perform_job(job)
        expected_result = args.stringify_keys!

        expect(result).to eq(expected_result)
      end
    end
  end
end
