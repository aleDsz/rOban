# frozen_string_literal: true

# Public: Create table `oban_jobs`
class CreateObanJobs < ActiveRecord::Migration[6.0]
  def up # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    execute <<-SQL
     CREATE TYPE oban_job_state AS ENUM (
      'available',
      'scheduled',
      'executing',
      'retryable',
      'completed',
      'discarded',
      'cancelled'
     );
    SQL

    create_table :oban_jobs, comment: '1' do |t|
      t.column :state, :oban_job_state, null: false, default: 'available'
      t.text :queue, null: false, default: 'default'
      t.text :worker, null: false
      t.jsonb :args, null: false, default: '{}'
      t.jsonb :attempt_errors, null: false, default: [], array: true
      t.integer :attempt, null: false, default: 0
      t.integer :max_attempts, null: false, default: 20
      t.timestamp :scheduled_at, null: false, default: 'NOW()'
      t.timestamp :attempted_at
      t.timestamp :completed_at
      t.text :attempted_by, array: true
      t.timestamp :discarded_at
      t.integer :priority, null: false, default: 0
      t.string :tags, default: [], array: true
      t.jsonb :meta, default: '{}'
      t.timestamp :cancelled_at

      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE oban_jobs ADD CONSTRAINT attempt_range CHECK (((attempt >= 0) AND (attempt <= max_attempts)));
      ALTER TABLE oban_jobs ADD CONSTRAINT positive_max_attempts CHECK ((max_attempts > 0));
      ALTER TABLE oban_jobs ADD CONSTRAINT priority_range CHECK (((priority >= 0) AND (priority <= 3)));
      ALTER TABLE oban_jobs ADD CONSTRAINT queue_length CHECK (((char_length(queue) > 0) AND (char_length(queue) < 128)));
      ALTER TABLE oban_jobs ADD CONSTRAINT worker_length CHECK (((char_length(worker) > 0) AND (char_length(worker) < 128)));
    SQL
  end

  def down
    drop_table :oban_jobs
    execute 'DROP TYPE oban_job_state;'
  end
end
