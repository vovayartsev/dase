module Dase
  module ARRelationInstanceMethods
    attr_accessor :dase_values

    def includes_count_of(*args)
      args.reject! { |a| a.blank? }
      options = args.extract_options!
      options.assert_valid_keys(:proc, :as, :only, :conditions, :group, :having, :limit, :offset, :joins, :include, :from, :lock)
      return self if args.empty?
      if options.present? and args.many?
        raise ArgumentError, "includes_count_of takes either multiple associations OR single association + options"
      end
      relation = clone
      relation.dase_values ||= {}
      args.each do |arg|
        opts = options.clone
        opts[:association] = arg.to_sym
        opts[:as] = (opts[:as] || "#{arg}_count").to_sym
        relation.dase_values[opts[:as]] = opts
      end
      relation
    end

    def attach_dase_counters_to_records
      (dase_values || {}).each do |_, options|
        Dase::Preloader.new(@records, options[:association], options).run
      end
    end

    def merge(r)
      super(r).tap do |result|
        # it's ok to get nil here - ActiveRecord works fine in that case
        if !r.nil? and r.dase_values.present?
          result.dase_values ||= {}
          result.dase_values.merge!(r.dase_values)
        end
      end
    end
  end
end

ActiveRecord::Relation.class_eval do
  include Dase::ARRelationInstanceMethods

  private

  alias_method :exec_queries_before_dase, :exec_queries

  def exec_queries
    after_hook = loaded? ? proc {} : proc { attach_dase_counters_to_records }
    exec_queries_before_dase.tap(&after_hook)
  end
end
