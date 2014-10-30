require "dase/version"
require "dase/preloader_methods"
require "dase/preloader"
require "dase/mp_active_record"

module Dase
  # take a look at mp_active_record files
  # (there we monkey-patch Active Record)

  # Syntax definition
  VALID_DASE_OPTIONS = [:as]
  VALID_ASSOCIATION_OPTIONS = [:proc, :where, :group, :having, :joins, :merge, :includes, :from]

  # Legacy syntax support
  VALID_SYNONYMS = {:only => :merge, :conditions => :where}
end
