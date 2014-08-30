module Dase
  module PreloaderMethods

    def initialize(klass, owners, reflection, preload_options)
      preload_options = preload_options.reject { |k, _| k == :association }
      @dase_counter_name = preload_options.delete(:as)
      @dase_scope_to_merge = preload_options.delete(:only)
      super(klass, owners, reflection, preload_options)
    end

    def prefixed_foreign_key
      "#{scoped.quoted_table_name}.#{reflection.foreign_key}"
    end

    def preload
      pk = model.primary_key.to_sym
      ids = owners.map(&pk)
      scope = records_for(ids)
      scope = scope.merge(@dase_scope_to_merge) if @dase_scope_to_merge
      counters_hash = scope.count(group: prefixed_foreign_key)
      owners.each do |owner|
        owner.define_singleton_method(@dase_counter_name) do
          counters_hash[owner[pk]] || 0
        end
      end
    end

  end
end