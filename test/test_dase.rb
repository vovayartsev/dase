require 'helper'

class TestBase < Test::Unit::TestCase

  context "includes_count_of" do
    setup do
      @bobby, @joe, @teddy = Author.order(:name).all
    end

    should "count books" do
      traditional_counts = Author.order(:name).map { |a| a.books.count }
      dase_counts = Author.includes_count_of(:books).order(:name).map { |a| a.books_count }
      # the order is: Bobby, Joe, Teddy - due to order(:name)
      true_counts = [1, 3, 0]   # see books.yml
      assert_equal true_counts, traditional_counts, "traditional counting failed - fixtures not loaded"
      assert_equal true_counts, dase_counts, "dase countings failed"
    end

    should "count old books" do
      traditional_counts = Author.order(:name).map { |a| a.old_books.count }
      dase_counts = Author.includes_count_of(:old_books).order(:name).map { |a| a.old_books_count }
      # the order is: Bobby, Joe, Teddy - due to order(:name)
      true_counts = [1, 2, 0]   # see books.yml
      assert_equal true_counts, traditional_counts, "traditional counting failed - fixtures not loaded"
      assert_equal true_counts, dase_counts, "dase countings failed"
    end
  end
end
