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
      [["create", "count", "Max[Nat]", 3], :ok],
      [["set", "count", 30], :ok],
      [["set", "count", 2], :ok],
      [["get", "count"], 30],

      [["ping"], :pong],

      [["create", "votes", "Map[Min[Timestamped[Str]]]"], :ok],
      [["set", "votes", "user1", [0, "candidate1"]], :ok],
      [["set", "votes", "user1", [10, "candidate2"]], :ok],
      [["get", "votes", "user1"], [0, "candidate1"]],

      [["create", "something", "Map[Max[Nat]]"], :ok],
      [["set", "something", "key1", 4], :ok],
      [["get", "something", "key1"], 4],
      [["set", "something", "key1", 10], :ok],
      [["get", "something", "key1"], 10],

      [["create", "users", "Map[Max[Timestamped[Map[Str]]]]"], :ok],
      [["set", "users", "user1", [10, { name: "bob" }]], :ok],
      [["get", "users", "user1"], [10, {:name=>"bob"}]],
      [["set", "users", "user1", [11, { name: "bobby" }]], :ok],
      [["get", "users", "user1"], [11, {:name=>"bobby"}]],
      [["set", "users", "user1", [9, { name: "bob the great" }]], :ok],
      [["get", "users", "user1"], [11, {:name=>"bobby"}]],
    ]

    commands.each do |(command, expected)|
      expect(db.handle(command)).to eq(expected)
    end
  end
end
