# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Oban::Job, type: :model do
  it 'creates a job' do
    job = described_class.new
    expect(job).not_to be nil
  end
end
