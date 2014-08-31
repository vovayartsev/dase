class Author < ActiveRecord::Base
  has_many :books
  has_many :old_books, -> { where year: 1990 }, class_name: 'Book'

  has_many :quotes, :through => :books
  has_many :scores, :through => :quotes

  scope :with_count_of_books, lambda { includes_count_of(:books) }

end
