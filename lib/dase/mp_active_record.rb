module Dase
  module RelationInstanceMethods
    def dase_values
      @dase_values ||= {}
    end

    def includes_count_of(*args)
      options = args.extract_options!
      extract_proc_argument(args, options)
      sanitize_dase_options(args, options)
      apply_synonyms(options)
      return self if args.empty?
      clone.tap do |relation|
        args.each do |arg|
          counter_name = (options[:as] || "#{arg}_count").to_sym
          relation.dase_values[counter_name] = options.merge(as: counter_name, association: arg.to_sym)
        end
      end
    end

    def extract_proc_argument(args, options)
      if args.last.is_a?(Proc)
        raise "Can't use :proc option together with ->{} syntax" if options.has_key?(:proc)
        options[:proc] = args.pop
      end
    end

    def merge(other)
      super(other).tap do |result|
        result.dase_values.merge!(other.dase_values) if other # other == nil is fine too
      end
    end

    private

    # legacy syntax support
    def apply_synonyms(options)
      VALID_SYNONYMS.each do |old, new|
        if options.has_key?(old)
          raise "Don't use #{old} and #{new} together" if options.has_key?(new)
          options[new] = options.delete(old)
        end
      end
    end

    def sanitize_dase_options(args, options)
      options.assert_valid_keys *(VALID_DASE_OPTIONS + VALID_ASSOCIATION_OPTIONS + VALID_SYNONYMS.keys)
      if options.present? and args.many?
        raise ArgumentError, 'includes_count_of takes either multiple associations OR single association + options'
      end
    end

    def attach_dase_counters_to_records
      (dase_values || {}).each do |_, options|
        Dase::Preloader.new(options).preload(@records, options[:association])
      end
    end
  end
end

ActiveRecord::Relation.class_eval do
  include Dase::RelationInstanceMethods

  private

  # why overwriting with include/extend doesn't work???
  alias_method :exec_queries_before_dase, :exec_queries

  def exec_queries
    after_hook = loaded? ? proc {} : proc { attach_dase_counters_to_records }
    exec_queries_before_dase.tap(&after_hook)
  end
end

class << ActiveRecord::Base
  delegate :includes_count_of, :to => :all
end

