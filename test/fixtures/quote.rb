class Quote < ActiveRecord::Base
  belongs_to :book
  #has_one :author, :through => :book
  has_many :scores, :class_name => 'Like', :foreign_key => "quote_id"
end