module Dase
  module PreloaderMethods

    def foreign_key
      reflection.klass.arel_table[reflection.foreign_key]
    end

    def preload(preloader)
      pk = model.primary_key.to_sym
      ids = owners.map(&pk)
      scope = records_for(ids)
      # scope = scope.merge(@dase_scope_to_merge) if @dase_scope_to_merge
      counters_hash = scope.group(foreign_key).count(Arel.star)
      owners.each do |owner|
        owner.define_singleton_method(preloader.dase_counter_name) do
          counters_hash[owner[pk]] || 0
        end
      end
    end

  end
end