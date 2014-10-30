module Dase
  module PreloaderMethods
    def foreign_key
      reflection.klass.arel_table[reflection.foreign_key]
    end

    def preload(preloader)
      pk = model.primary_key.to_sym
      ids = owners.map(&pk)
      scope = records_for(ids)

      # applying options like :where => ... or :conditions => ..., or -> {....}
      scope = apply_association_options(preloader.options.clone, scope)

      # the actual magic of attaching counters to the records comes here
      counters_hash = scope.group(foreign_key).count(Arel.star)
      owners.each do |owner|
        owner.define_singleton_method(preloader.options[:as]) do
          counters_hash[owner[pk]] || 0
        end
      end
    end

    def apply_association_options(options, scope)
      proc = options.delete(:proc)

      # applying proc syntax: -> {...}
      scope = scope.instance_eval(&proc) if proc

      options.slice(*VALID_ASSOCIATION_OPTIONS).each do |key, value|
        scope = scope.send(key, value)
      end

      scope
    end

  end
end