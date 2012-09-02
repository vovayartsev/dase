require 'helper'

class TestBase < Test::Unit::TestCase

  def compare_counts(traditional, dase, true_counts)
    assert_equal true_counts, traditional, "traditional counting failed - fixtures not loaded"
    assert_equal true_counts, dase, "dase countings failed"
  end

  context "includes_count_of" do
    setup do
      @bobby, @joe, @teddy = Author.order(:name).all
    end

    should "count books" do
      traditional_counts = Author.order(:name).map { |a| a.books.count }
      dase_counts = Author.includes_count_of(:books).order(:name).map { |a| a.books_count }
      # the order is: Bobby, Joe, Teddy - due to order(:name)
      true_counts = [1, 3, 0] # see books.yml
      compare_counts(traditional_counts, dase_counts, true_counts)
    end

    should "respond_to the counter method" do
      assert_equal true, Author.includes_count_of(:books).first.respond_to?(:books_count), "doesn't respond'"
    end

    should "count old books" do
      traditional_counts = Author.order(:name).map { |a| a.old_books.count }
      dase_counts = Author.includes_count_of(:old_books).order(:name).map { |a| a.old_books_count }
      # the order is: Bobby, Joe, Teddy - due to order(:name)
      true_counts = [1, 2, 0] # see books.yml
      compare_counts(traditional_counts, dase_counts, true_counts)
    end

    should "count books for year 1990" do
      traditional_counts = Author.order(:name).map { |a| a.books.where(year: 1990).count }
      dase_counts = Author.includes_count_of(:books, :conditions => {:year => 1990}).order(:name).map { |a| a.books_count }
      # the order is: Bobby, Joe, Teddy - due to order(:name)
      true_counts = [1, 2, 0] # see books.yml
      compare_counts(traditional_counts, dase_counts, true_counts)
    end

    # Not yet implemented
    #should "count quotations" do
    #  traditional_counts = Author.order(:name).map { |a| a.quotes.count }
    #  dase_counts = Author.order(:name).includes_count_of(:quotes).map { |a| a.quotes_count }
    #  # the order is: Bobby, Joe, Teddy - due to order(:name)
    #  true_counts = [2, 1, 0] # see quotes.yml
    #  compare_counts(traditional_counts, dase_counts, true_counts)
    #end
  end
end
