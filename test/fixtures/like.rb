class Like < ActiveRecord::Base
  belongs_to :quote
  has_one :author, :through => :quote
end