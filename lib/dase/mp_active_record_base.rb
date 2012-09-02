# Monkey-patching ActiveRecord::Base to add xxx_count methods to it

module Dase
  module ARBaseInstanceMethods
    def set_dase_counter(name, value)
      @dase_counters ||= {}
      @dase_counters[name] = value
    end

    def get_dase_counter(name)
      @dase_counters[name]
    end

    def respond_to?(*args)
      @dase_counters && @dase_counters.has_key?(args.first) || super
    end

    def method_missing(name, *args)
      if @dase_counters and @dase_counters.has_key?(name.to_sym)
        get_dase_counter(name, *args)
      else
        super
      end
    end

    private

    def self.included(klass)
      class << klass
        delegate :includes_count_of, :to => :scoped
      end
    end
  end
end

ActiveRecord::Base.class_eval do
  include Dase::ARBaseInstanceMethods
end
