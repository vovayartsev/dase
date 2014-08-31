module Dase
  class Preloader < ::ActiveRecord::Associations::Preloader

    # custom preloaders for different association types

    class HasMany < ::ActiveRecord::Associations::Preloader::HasMany
      include Dase::PreloaderMethods
    end

    # Not fully implemented yet
    class HasManyThrough < ::ActiveRecord::Associations::Preloader::HasManyThrough
      include Dase::PreloaderMethods

      def prefixed_foreign_key
        "#{reflection.active_record.table_name}.#{reflection.active_record_primary_key}"
      end

      def records_for(ids)
        reflection.active_record.joins(reflection.name).
            where(prefixed_foreign_key => ids)
      end
    end

    attr_reader :dase_counter_name

    def initialize(dase_counter_name)
      @dase_counter_name = dase_counter_name
    end

    # an overloaded version of ActiveRecord::Associations::Preloader's preloader_for
    # which returns a class of a custom preloader for a given association
    def preloader_for(reflection, owners, rhs_klass)
      return NullPreloader unless rhs_klass

      if owners.first.association(reflection.name).loaded?
        return AlreadyLoaded
      end

      case reflection.macro
        when :has_many
          reflection.options[:through] ? HasManyThrough : HasMany
        when :has_one, :belongs_to
          raise ArgumentError, "You can't use includes_count_of with a #{reflection.macro} association"
        else
          raise NotImplementedError, "#{reflection.macro} not supported"
      end
    end
  end

end