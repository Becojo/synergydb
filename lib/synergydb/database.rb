require 'synergydb/types'

module Synergydb
  class Database
    attr_reader :collections

    def initialize
      @collections = {}
    end

    def create(name, type, value=nil)
      begin
        type = Synergydb::Types.class_eval(type.gsub(/[^\[\],a-z]/i, '')) # whatev
      rescue NameError => e
        return [:err, "Unknown type #{e.name}"]
      end

      @collections[name] = { type: type, value: type.create(value) }
      [:ok, name]
    end

    def set(name, *args)
      status, @collections[name][:value] = @collections[name][:value].set(*args)
      [status]
    end

    def get(name, *args)
      if @collections.has_key? name
        [:ok, @collections[name][:value].get(*args)]
      else
        [:err, "No such key"]
      end
    end

    def ping
      [:ok, :pong]
    end

    def sync(*args)
      [:err, "Not implemented"]
    end

    def handle(command)
      begin
        method, *args = command
        if %w{ping get set create sync}.include? method
          send(*command)
        else
          [:err, "Unknown command"]
        end
      rescue Exception => e
        [:err, e]
      end
    end
  end
end
