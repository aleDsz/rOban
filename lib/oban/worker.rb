# frozen_string_literal: true

module Oban
  # Public: The Worker module
  module Worker
    # Public: Inject methods into class that includes `Oban::Worker`
    module ClassMethods
      def worker_opts(opts = {})
        @worker_opts ||= opts
      end

      def worker_attribute(*_attrs); end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    # Public: The Worker abstract class
    class << self
      Job = Oban::Job

      def initialize(args, opts = {})
        @opts = worker_opts(opts)
        Job.new({ args: args, **resolve_opts(opts) })
      end

      def worker_opts(opts = {})
        super
      end

      private

      def __opts__
        @opts.merge({ worker: name.to_s })
      end

      def resolve_opts(opts); end
    end
  end
end
