# Dase

The gem is named by the german mathematician [Johann Dase](http://en.wikipedia.org/wiki/Zacharias_Dase),
who was a mental calculator - he could count and multiply numbers very quickly. Dase gem adds extra speed 
to Active Record whenever you need to calculate the number of associated records.

Here's an example of the code that will cause N + 1 queries:

```
  Author.find_each do |author|
    cnt = author.books.where(year: 1992).count
    puts "#{author.name} has published #{cnt} books in 1992"
  end
```

Active Record has a built-in solution for efficient fetching of
associated records - see [Rails Guides](http://guides.rubyonrails.org/active_record_querying.html#eager-loading-associations)
```
  authors = Author.includes(:books)  # => will cause only 2 queries
  authors.first                      
```

The Dase gem provides a similar solution for the efficient counting of associated records:
```
  authors = Author.includes_count_of(:books)  # => will cause only 2 queries
  authors.first.books_count                   
```


## Installation

Add this line to your application's Gemfile:

    gem 'dase', "~> 3.2.0"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dase

### Note on version numbers

Dase version number correlates with the Active Record's versions number,
which it has been tested with.
E.g. the latest 3.2.* version of Dase will play nicely with the latest 3.2.* version of Active Record.
Since it's a sort of a "hack", make sure you specified the version number for "dase" gem in your Gemfile.

## Usage

### Basic usage:

```
  Author.includes_count_of(:books).find_each do |author|
    puts "#{author.name} has #{author.books_count} books published"
  end
```

### Advanced usage:

You can specify a hash of options which will be passed to the underlying finder 
which retrieves the association. Valid keys are: :conditions, :group, :having, :joins, :include
```
Author.includes_count_of(:books, :conditions => {:year => 1990})
```

## How it works

The equivalent code would look something like this:
```
  counters_hash = Book.count(:group => :author_id)
  Author.find_each do |author|
    puts "#{author.name} has #{counters_hash[author.id] || 0} books published"
  end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
