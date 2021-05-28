# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Oban::Job, type: :model do # rubocop:disable Metrics/BlockLength
  Job = described_class # rubocop:disable Lint/ConstantDefinitionInBlock

  context 'with ORM operations' do
    it 'instantiates a job' do
      job = Job.new
      expect(job).not_to be nil
    end

    it 'inserts a job' do
      job = Job.create!(worker: 'Foo')

      expect(job.created_at).not_to be nil
      expect(job.args).to eq({}.to_s)
      expect(job.worker).to eq('Foo')
    end

    it 'updates a job' do
      job = Job.create!(worker: 'Foo')
      job.update!(attempt: 1, state: 'completed', completed_at: Time.now)

      expect(job.completed_at).not_to be nil
      expect(job.worker).to eq('Foo')
      expect(job.attempt).to eq(1)
      expect(job.state).to eq('completed')
    end

    it 'deletes a job' do
      job = Job.create!(worker: 'Foo')
      job_id = job.id
      job.destroy

      expect { Job.find(job_id) }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'with validations' do
    it 'throws an error when worker isn\'t defined' do
      expect { Job.create! }
        .to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
