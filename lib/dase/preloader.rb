module Dase
  class Preloader < ::ActiveRecord::Associations::Preloader

    # custom preloaders for different association types
    class HasMany < ::ActiveRecord::Associations::Preloader::HasMany
      include Dase::PreloaderMethods
    end
    class HasManyThrough < ::ActiveRecord::Associations::Preloader::HasManyThrough
      include Dase::PreloaderMethods
    end
    class HasAndBelongsToMany < ::ActiveRecord::Associations::Preloader::HasAndBelongsToMany
      include Dase::PreloaderMethods
    end

    # an overloaded version of ActiveRecord::Associations::Preloader's preloader_for
    # which instantiates a custom preloader for a given association
    def preloader_for(reflection)
      case reflection.macro
        when :has_many
          reflection.options[:through] ? HasManyThrough : HasMany
        when :has_one, :belongs_to
          raise ArgumentError, "You can't use includes_count_of with a #{reflection.macro} association"
        when :has_and_belongs_to_many
          HasAndBelongsToMany
      end
    end
  end

end