module Dase
  module PreloaderMethods

    def initialize(klass, owners, reflection, preload_options)
      # grabbing our options
      preload_options = preload_options.clone
      @dase_counter_name = preload_options.delete(:as)
      @dase_scope_to_merge = preload_options.delete(:only)
      super(klass, owners, reflection, preload_options)
    end

    def preload
      counter_name = @dase_counter_name || "#{reflection.name}_count".to_sym
      pk = model.primary_key.to_sym
      ids = owners.map(&pk)
      fk = "#{scoped.quoted_table_name}.#{reflection.foreign_key}"
      scope = records_for(ids)
      scope = scope.merge(@dase_scope_to_merge) if @dase_scope_to_merge
      counters_hash = scope.count(group: fk)
      owners.each do |owner|
        value = counters_hash[owner[pk]] || 0 # 0 is "default count", when no records found
        owner.set_dase_counter(counter_name, value)
      end
    end

  end
end