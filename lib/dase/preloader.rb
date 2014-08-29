module Dase
  class Preloader < ::ActiveRecord::Associations::Preloader

    # custom preloaders for different association types

    class HasMany < ::ActiveRecord::Associations::Preloader::HasMany
      include Dase::PreloaderMethods
    end

    class HasAndBelongsToMany < ::ActiveRecord::Associations::Preloader::HasAndBelongsToMany
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

    # an overloaded version of ActiveRecord::Associations::Preloader's preloader_for
    # which returns a class of a custom preloader for a given association
    def preloader_for(reflection)
      case reflection.macro
        when :has_many
          if reflection.options[:through]
            HasManyThrough
            #raise NotImplementedError, "The support for HasManyThrough associations is not implemented yet"
          else
            HasMany
          end
        when :has_one, :belongs_to
          raise ArgumentError, "You can't use includes_count_of with a #{reflection.macro} association"
        when :has_and_belongs_to_many
          HasAndBelongsToMany
      end
    end
  end

end