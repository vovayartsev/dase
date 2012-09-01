module Dase
  module ARRelationInstanceMethods
    attr_accessor :dase_values

    def includes_count_of(*args)
      args.reject! { |a| a.blank? }
      options = args.extract_options!
      options.assert_valid_keys(:conditions, :group, :having, :limit, :offset, :joins, :include, :from, :lock)
      return self if args.empty?
      relation = clone
      relation.dase_values ||= {}
      args.each { |a| relation.dase_values[a] = options}
      relation
    end

    def attach_dase_counters_to_records
      if dase_values.present? and !@has_dase_counters
        dase_values.each do |associations, options|
          Dase::Preloader.new(@records, associations, options).run
        end
        @has_dase_counters = true
      end
    end
  end
end


ActiveRecord::Relation.class_eval do
  include Dase::ARRelationInstanceMethods

  private

  alias_method :exec_queries_before_dase, :exec_queries

  def exec_queries
    exec_queries_before_dase # original method from ActiveRecord
    attach_dase_counters_to_records
    @records
  end
end