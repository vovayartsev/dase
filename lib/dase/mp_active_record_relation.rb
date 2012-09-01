module Dase
  module ARRelationInstanceMethods
    attr_accessor :dase_values

    def includes_count_of(*args)
      args.reject! { |a| a.blank? }
      return self if args.empty?
      relation = clone
      relation.dase_values = ((relation.dase_values || []) + args).flatten.uniq
      relation
    end

    def attach_dase_counters_to_records
      if dase_values.present? and !@has_dase_counters
        dase_values.each do |associations|
          Dase::Preloader.new(@records, associations).run
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