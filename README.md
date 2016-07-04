# SynergyDB

_Experimental key-value, conflict-free database written in Ruby_

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'synergydb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install synergydb

## Example

```
>> create votes HashTable[Min[Timestamped[Str]]]
=> "ok"

>> set votes user1 [1467596021814, "candidate1"]
=> "ok"

>> get votes user1
=> [1467596021814, "candidate1"]

>> set votes user1 [1467596021914, "candidate2"]
=> "ok"

>> get votes user1
=> [1467596021814, "candidate1"]
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
