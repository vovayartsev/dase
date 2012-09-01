class Book < ActiveRecord::Base
  attr_accessible :title, :year

  belongs_to :author

end
