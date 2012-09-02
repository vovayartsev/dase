class Book < ActiveRecord::Base
  attr_accessible :title, :year

  belongs_to :author
  has_many :quotes

end
