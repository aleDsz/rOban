# frozen_string_literal: true

module Oban
  # Public: The Worker module
  module Worker
    # Options class to include some metaprogramming methods
    module Options
      def self.included(base)
        base.extend(ClassMethods)
        base.oban_class_attribute :oban_worker_options
        base.oban_class_attribute :job
        base.oban_class_attribute :args
      end

      # Options metaprogramming methods
      module ClassMethods
        ACCESSOR_MUTEX = Mutex.new

        def worker_options(opts = {})
          opts = opts.transform_keys(&:to_sym)
          self.oban_worker_options = options.merge(opts)
        end

        def options
          oban_worker_options || { queue: 'default' }
        end

        def oban_class_attribute(*attrs) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
          instance_reader = true
          instance_writer = true

          attrs.each do |name| # rubocop:disable Metrics/BlockLength
            synchronized_getter = "__synchronized_#{name}"

            singleton_class.instance_eval do
              undef_method(name) if method_defined?(name) || private_method_defined?(name)
            end

            define_singleton_method(synchronized_getter) { nil }

            singleton_class.class_eval do
              private(synchronized_getter)
            end

            define_singleton_method(name) { ACCESSOR_MUTEX.synchronize { send synchronized_getter } }

            ivar = "@#{name}"

            singleton_class.instance_eval do
              m = "#{name}="
              undef_method(m) if method_defined?(m) || private_method_defined?(m)
            end

            define_singleton_method("#{name}=") do |val|
              singleton_class.class_eval do
                ACCESSOR_MUTEX.synchronize do
                  if method_defined?(synchronized_getter) || private_method_defined?(synchronized_getter)
                    undef_method(synchronized_getter)
                  end
                  define_method(synchronized_getter) { val }
                end
              end

              if singleton_class?
                class_eval do
                  undef_method(name) if method_defined?(name) || private_method_defined?(name)

                  define_method(name) do
                    if instance_variable_defined? ivar
                      instance_variable_get ivar
                    else
                      singleton_class.send name
                    end
                  end
                end
              end

              val
            end

            if instance_reader
              undef_method(name) if method_defined?(name) || private_method_defined?(name)
              define_method(name) do
                if instance_variable_defined?(ivar)
                  instance_variable_get ivar
                else
                  self.class.public_send name
                end
              end
            end

            next unless instance_writer

            m = "#{name}="
            undef_method(m) if method_defined?(m) || private_method_defined?(m)
            attr_writer name
          end
        end
      end
    end

    def self.included(base)
      message = "Oban::Worker cannot be included in an ActiveJob: #{base.name}"
      base_active_job = base.ancestors.any? { |c| c.name == 'ActiveJob::Base' }

      raise ArgumentError, message if base_active_job

      base.include(Options)
      base.extend(ClassMethods)
    end

    def self.perform_job(job)
      worker = job.worker
      klass = job.worker.constantize.new

      raise ArgumentError, "#{worker} doesn't implements the method perform" unless klass.methods.include?(:perform)

      klass = job.worker.constantize.new
      klass.job = job
      klass.args = job.args

      klass.perform
    end

    # Public: Export functions to custom worker class
    module ClassMethods
      def perform_async(args, options = {})
        params = {
          args: args,
          worker: name,
          state: 'available'
        }.merge(options)

        Job.create(params)
      end
    end
  end
end
