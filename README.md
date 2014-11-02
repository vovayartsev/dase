[![Build Status](https://secure.travis-ci.org/vovayartsev/dase.png)](http://travis-ci.org/vovayartsev/dase)

## Overview

Dase gem provides `includes_count_of` method on a relation, which works similar to ActiveRecord's `preload` method and solves [N+1 query problem](http://guides.rubyonrails.org/active_record_querying.html#eager-loading-associations) when counting records in `has_many` ActiveRecord associations.

## Usage

Given this data in the DB:
![Dase example](https://dl.dropboxusercontent.com/u/8560625/dase.png)

and this Rails model definition
```ruby
class Author
  has_many :articles
end
```
you can now write this:
```
  authors = Author.includes_count_of(:articles)
  billy = authors.first    # => #<Author name: 'Billy'>                
  billy.articles_count     # => 2                
```

with conditions on associated records
```
  Author.includes_count_of(:articles, where: {year: 2012} )        #  only the articles published in 2012
  Author.includes_count_of(:articles, -> { where(year: 2012) } )   #  [Rails 4.1 and greater] the same using lambda syntax
```

with renamed counter method
```
  Author.includes_count_of(:articles, where: {year: 2012}, as: :number_of_articles_in_2012)
```

with multiple associations counted at once
```
  Author.includes_count_of(:articles, :photos, :tweets)
```

## Installation

| Rails version | Add this to Gemfile    |
|---------------|------------------------|
| 3.2.x         | gem 'dase', '~> 3.2.0' |
| 4.0.x         |    ----- N/A -----     |
| 4.1.x         | gem 'dase', '~> 4.1.0' |
| 4.2.x         | coming soon            |

## Under the hood

When a relation is "materialized", we run a custom preloader which calculates the hash of counters in a single SQL query like this:
```
  counters_hash = Article.where(:year => 2012).count(:group => :author_id)
```
then we add counters to the parent records like this:
```
  define_method(:articles_count) { counters_hash[author.id] || 0 }
```

## Name origin

The gem is named by the german mathematician [Johann Dase](http://en.wikipedia.org/wiki/Zacharias_Dase),
who was a [mental calculator](http://en.wikipedia.org/wiki/Mental_calculator) and could add and multiply numbers very quickly. 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/vovayartsev/dase/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

