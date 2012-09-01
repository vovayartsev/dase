# Dase

German mathematician Johann Dase was a mental calculator - he could count and multiply numbers very quickly.

http://en.wikipedia.org/wiki/Zacharias_Dase

Dase gem adds extra speed to Active Record whenever you need to calculate the number of
associated records, like this:

```
  Author.find_each do |author|
    cnt = author.books.where(year: 1992).count
    puts "#{author.name} has published #{cnt} books in 1992"
  end
```

That's a solution for one of the cases of N + 1 querying problem
described in Rails Guides here:

http://guides.rubyonrails.org/active_record_querying.html#eager-loading-associations


## Installation

Add this line to your application's Gemfile:

    gem 'dase', "~> 3.2.0"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dase

Note: the Dase gem's version number correlates with the Active Record's versions number,
which it has been tested with.
E.g. the latest 3.2.* version of Dase will play nicely with the latest 3.2.* version of Active Record.
Since it's a sort of a "hack", make sure you specified the version number for "dase" gem in your Gemfile.

## Usage

Basic usage:

```
  Author.includes_count_of(:books).find_each do |author|
    puts "#{author.name} has #{author.books_count} books published"
  end
```

Advanced usage:

TBD

## How it works

TBD

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
