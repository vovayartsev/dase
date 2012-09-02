module Dase
  module PreloaderMethods
    def preload
      counter_name = "#{reflection.name}_count".to_sym
      pk = model.primary_key.to_sym
      ids = owners.map(&pk)
      fk = "#{scoped.quoted_table_name}.#{reflection.foreign_key}"
      counters_hash = records_for(ids).count(group: fk)
      owners.each do |owner|
        value = counters_hash[owner[pk]] || 0 # 0 is "default count", when no records found
        owner.set_dase_counter(counter_name, value)
      end
    end
  end
end