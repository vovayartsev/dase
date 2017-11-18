require 'helper'

describe 'includes_count_of' do
  def compare_counts(traditional, dase, true_counts)
    assert_equal true_counts, traditional, "traditional counting failed - fixtures not loaded"
    assert_equal true_counts, dase, "dase countings failed"
  end

  before do
    @bobby, @joe, @teddy = Author.order(:name).all
  end

  it 'should count books' do
    traditional_counts = Author.order(:name).map { |a| a.books.count }
    dase_counts = Author.includes_count_of(:books).order(:name).map { |a| a.books_count }
    # the order is: Bobby, Joe, Teddy - due to order(:name)
    true_counts = [1, 3, 0] # see books.yml
    compare_counts(traditional_counts, dase_counts, true_counts)
  end

  it 'should respond_to the counter method' do
    assert_equal true, Author.includes_count_of(:books).first.respond_to?(:books_count), "doesn't respond'"
  end

  it 'should sneeze through scope definitions' do
    assert_equal true, Author.with_count_of_books.first.respond_to?(:books_count), "doesn't respond'"
  end

  it 'should support :as option' do
    assert_equal true, Author.includes_count_of(:books, :as => :my_count).first.respond_to?(:my_count), "doesn't respond'"
  end

  it 'should support old_books_count and new_books_count simultaneously using :as option' do
    scope = Author.includes_count_of(:books, :conditions => {:year => 2012}, :as => :new_books_count).
        includes_count_of(:books, :conditions => {:year => 1990}, :as => :old_books_count)
    dase_counts = scope.order(:name).map { |a| [a.old_books_count, a.new_books_count] }
    # the order is Bobby[:old, :new],  Joe[:old, :new],  Teddy[:old, :new]
    true_counts = [[1, 0], [2, 1], [0, 0]] # see books.yml
    assert_equal true_counts, dase_counts, "results mismatch"
  end

  it 'should count old books' do
    traditional_counts = Author.order(:name).map { |a| a.old_books.count }
    dase_counts = Author.includes_count_of(:old_books).order(:name).map { |a| a.old_books_count }
    # the order is: Bobby, Joe, Teddy - due to order(:name)
    true_counts = [1, 2, 0] # see books.yml
    compare_counts(traditional_counts, dase_counts, true_counts)
  end

  it 'should count books for year 1990' do
    traditional_counts = Author.order(:name).map { |a| a.books.where(:year => 1990).count }
    dase_counts = Author.includes_count_of(:books, :conditions => {:year => 1990}).order(:name).map { |a| a.books_count }
    # the order is: Bobby, Joe, Teddy - due to order(:name)
    true_counts = [1, 2, 0] # see books.yml
    compare_counts(traditional_counts, dase_counts, true_counts)
  end

  it 'should support :proc option (where year 1990)' do
    traditional_counts = Author.order(:name).map { |a| a.books.where(:year => 1990).count }
    dase_counts = Author.includes_count_of(:books, :proc => proc { where(:year => 1990) }).order(:name).map { |a| a.books_count }
    # the order is: Bobby, Joe, Teddy - due to order(:name)
    true_counts = [1, 2, 0] # see books.yml
    compare_counts(traditional_counts, dase_counts, true_counts)
  end

  it 'should support lambda syntax (where year 1990)' do
    traditional_counts = Author.order(:name).map { |a| a.books.where(:year => 1990).count }
    dase_counts = Author.includes_count_of(:books, lambda { where(:year => 1990) }).order(:name).map { |a| a.books_count }
    # the order is: Bobby, Joe, Teddy - due to order(:name)
    true_counts = [1, 2, 0] # see books.yml
    compare_counts(traditional_counts, dase_counts, true_counts)
  end

  it 'should count books for year 2012 using :only option' do
    dase_counts = Author.includes_count_of(:books, :only => Book.year2012).order(:name).map { |a| a.books_count }
    # the order is: Bobby, Joe, Teddy - due to order(:name)
    true_counts = [0, 1, 0] # see books.yml
    assert_equal true_counts, dase_counts, "results mismatch"
  end

  # it 'should allow merge (nil) on a scope with includes_count_of' do
  #   assert_equal 3, Author.includes_count_of(:books).merge(nil).all.size
  # end

  # pending "apply: lambda {where...}"

  it 'should count likes' do
    dase_counts = Author.order(:name).includes_count_of(:scores).map { |a| a.scores_count }
    # the order is: Bobby, Joe, Teddy - due to order(:name)
    true_counts = [0, 2, 0] # see likes.yml
    assert_equal true_counts, dase_counts, "results mismatch"
  end

  it 'should count quotations' do
    traditional_counts = Author.order(:name).map { |a| a.quotes.count }
    dase_counts = Author.order(:name).includes_count_of(:quotes).map { |a| a.quotes_count }
    # the order is: Bobby, Joe, Teddy - due to order(:name)
    true_counts = [2, 1, 0] # see quotes.yml
    compare_counts(traditional_counts, dase_counts, true_counts)
  end

  it 'should support multiple arguments' do
    joe = Author.includes_count_of(:books, :old_books).where(:name => 'Joe').first
    assert_equal 3, joe.books_count, "Invalid books_count"
    assert_equal 2, joe.old_books_count, "Invalid old_books_count"
  end

  it 'should work with find_each' do
    # the order is: Bobby, Joe, Teddy - due to sort_by(:name)
    records = []
    Author.includes_count_of(:books).find_each(batch_size: 2) { |r| records << r }
    dase_count = records.sort_by(&:name).map { |a| a.books_count }
    assert_equal [1, 3, 0], dase_count, "dase countings failed" # see books.yml
  end
end
