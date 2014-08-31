class Book < ActiveRecord::Base
  belongs_to :author
  has_many :quotes

  scope :year2012, lambda{ where(:year => 2012) }

end
