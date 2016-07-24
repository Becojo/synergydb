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
      (status, *response), value = @collections[name][:value].set(*args)

      if status == :ok
        @collections[name][:value] = value
      end

      [status] + response
    end

    def get(name, *args)
      if @collections.has_key? name
        @collections[name][:value].get(*args)
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

    def type(name)
      if @collections.has_key? name
        [:ok, @collections[name][:type].to_s.gsub('Synergydb::Types::', '')]
      else
        [:err, "No such key"]
      end
    end

    def handle(command)
      begin
        method, *args = command
        if %w{ping get set create sync type}.include? method
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
