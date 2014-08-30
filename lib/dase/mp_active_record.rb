module Dase
  module ARRelationInstanceMethods
    def dase_values
      @dase_values ||= {}
    end

    def includes_count_of(*args)
      options = args.extract_options!
      sanitize_includes_count_of_options(args, options)
      return self if args.empty?
      clone.tap do |relation|
        args.each do |arg|
          counter_name = (options[:as] || "#{arg}_count").to_sym
          relation.dase_values[counter_name] = options.merge(as: counter_name, association: arg.to_sym)
        end
      end
    end

    def merge(other)
      super(other).tap do |result|
        result.dase_values.merge!(other.dase_values || {}) if other # other == nil is fine too
      end
    end

    private

    def sanitize_includes_count_of_options(args, options)
      options.assert_valid_keys(:proc, :as, :only, :conditions, :group, :having, :limit, :offset, :joins, :include, :from, :lock)
      if options.present? and args.many?
        raise ArgumentError, 'includes_count_of takes either multiple associations OR single association + options'
      end
    end

    def attach_dase_counters_to_records
      (dase_values || {}).each do |_, options|
        Dase::Preloader.new(@records, options[:association], options).run
      end
    end
  end
end

ActiveRecord::Relation.class_eval do
  include Dase::ARRelationInstanceMethods

  private

  # why overwriting with include/extend doesn't work???
  alias_method :exec_queries_before_dase, :exec_queries

  def exec_queries
    after_hook = loaded? ? proc {} : proc { attach_dase_counters_to_records }
    exec_queries_before_dase.tap(&after_hook)
  end
end

class << ActiveRecord::Base
  delegate :includes_count_of, :to => :scoped
end

