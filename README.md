# SynergyDB

_Experimental key-value, conflict-free database written in Ruby_


[![Travis CI](https://travis-ci.org/Becojo/synergydb.svg?branch=master)](https://travis-ci.org/Becojo/synergydb) [![BADGINATOR](https://badginator.herokuapp.com/becojo/synergydb.svg)](https://github.com/Becojo/synergydb)

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

1. Start the server with `synergy-server`
2. Start an interactive client with `synergy-client`

```
>> db.create(:votes, Map[Min[Timestamped[Str]]])
=> ["ok"]

>> db.votes.set(:user1, [1467596021814, "candidate1"])
=> ["ok"]

>> db.votes.get(:user1)
=> ["ok", [1467596021814, "candidate1"]]

>> db.votes.set(:user1, [1467596021815, "candidate2"])
=> ["ok"]

>> db.votes.get(:user1)
=> ["ok", [1467596021814, "candidate1"]]
```

## Types

### `Map[T]`
Represents a key-value object. The type of the keys are always strings and the value type `T` defines an idempotent, commutative and associative operation.

### `Timestamped[T]`
Represents a value at a given point of time. The type `T` can be anything, the order of this type is solely based on the timestamp.

### `Max[T]`
Max type that when merged returns that largest value. The type `T` must be orderable.

### `Min[T]`
Min type that when merged returns that smallest value. The type `T` must be orderable.

### `Nat`
Represents a natural number.

### `Str`
Represents a string. This type is not orderable.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
