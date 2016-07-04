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
      ["create", "count", "Max[Nat]", 3],
      ["set", "count", 30],
      ["set", "count", 2],
      ["get", "count", 3],

      ["ping"],

      ["create", "votes", "Map[Min[Timestamped[Str]]]"],
      ["set", "votes", "user1", [0, "candidate1"]],
      ["set", "votes", "user1", [10, "candidate2"]],
      ["get", "votes", "user1"],

      ["create", "something", "Map[Max[Nat]]"],
      ["set", "something", "key1", 4],
      ["get", "something", "key1"],
      ["set", "something", "key1", 10],
      ["get", "something", "key1"],

      ["create", "users", "Map[Min[Timestamped[Map[Str]]]]"],
      ["set", "users", "user1", [10, { name: "bob" }]],
      ["get", "users", "user1"],
      ["set", "users", "user1", [11, { name: "bob" }]],
      ["get", "users", "user1"]
    ]

    commands.each do |command|
      puts command.to_json
      print "=> "
      puts db.handle(command).to_json
      puts
    end
  end
end
