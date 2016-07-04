require 'synergydb/types'

module Synergydb
  class Database
    attr_reader :collections

    def initialize
      @collections = {}
    end

    def create(name, type, value=nil)
      type = Synergydb::Types.class_eval(type.gsub(/[^\[\],a-z]/i, '')) # whatev
      @collections[name] = { type: type, value: type.create(value) }
      :ok
    end

    def set(name, *args)
      [:ok, @collections[name][:value].set(*args).unwrap]
    end

    def get(name, *args)
      @collections[name][:value].get(*args)
    end

    def ping
      :pong
    end

    def handle(command)
      method, *args = command
      send(method, *args)
    end
  end
end
