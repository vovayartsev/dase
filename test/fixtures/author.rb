class Author < ActiveRecord::Base
  attr_accessible :name

  has_many :books
  has_many :old_books, :class_name => "Book", :conditions => {:year => 1990}

  has_many :quotes, :through => :books

  scope :with_count_of_books, lambda { includes_count_of(:books) }

end
