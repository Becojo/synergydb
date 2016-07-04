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
>> create votes Map[Min[Timestamped[Str]]]
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

## Types

### `Map[T]`
Represents a key-value object. The type of the keys are always strings and the value type `T` defines an idempotent, commutative and associative operation.

### `Timestamped[T]`
Represents a value at a given point of time. The type `T` can be anything, the order of this type is solely based on the timestamp.

### `Max[T]`
- Mergable
Defines a join-semilattice. The type `T` must be orderable.

### `Min[T]`
- Mergable
Defines a meet-semilattice. The type `T` must be orderable.

### `Nat`
- Orderable
Represents a natural number.

### `Str`
Represents a string. This type is not orderable.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
