require 'spec_helper'
require 'json'
require 'synergydb/database'

describe Synergydb do
  it 'has a version number' do
    expect(Synergydb::VERSION).not_to be nil
  end

  it 'does something useful' do
    db = Synergydb::Database.new

    commands = [
      [["create", "count", "Max[Int]", 3], [:ok, "count"]],
      [["set", "count", 30], [:ok]],
      [["set", "count", 2], [:ok]],
      [["get", "count"], [:ok, 30]],

      [["ping"], [:ok, :pong]],

      [["create", "votes", "Map[Min[Timestamped[Str]]]"], [:ok, "votes"]],
      [["set", "votes", "user1", [0, "candidate1"]], [:ok]],
      [["set", "votes", "user1", [10, "candidate2"]], [:ok]],
      [["get", "votes", "user1"], [:ok, [0, "candidate1"]]],

      [["create", "something", "Map[Max[Int]]"], [:ok, "something"]],
      [["set", "something", "key1", 4], [:ok]],
      [["get", "something", "key1"], [:ok, 4]],
      [["set", "something", "key1", 10], [:ok]],
      [["get", "something", "key1"], [:ok, 10]],

      [["create", "users", "Map[Max[Timestamped[Map[Str]]]]"], [:ok, 'users']],
      [["set", "users", "user1", [10,  { name: "bob" }]], [:ok]],
      [["get", "users", "user1"], [:ok, [10, { name: "bob" }]]],
      [["set", "users", "user1", [11,  { name: "bobby" }]], [:ok]],
      [["get", "users", "user1"], [:ok, [11, { name: "bobby"}]]],
      [["set", "users", "user1", [9,   { name: "bob the great" }]], [:ok]],
      [["get", "users", "user1"], [:ok, [11, { name: "bobby"}]]],
    ]

    commands.each do |(command, expected)|
      expect(db.handle(command)).to eq(expected)
    end
  end
end
