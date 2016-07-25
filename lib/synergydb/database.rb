require 'synergydb/types'

module Synergydb
  class Database
    attr_reader :collections

    def initialize
      @collections = {}
    end

    def create(name, type, value = nil)
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

      @collections[name][:value] = value if status == :ok

      [status] + response
    end

    def get(name, *args)
      if @collections.key? name
        @collections[name][:value].get(*args)
      else
        [:err, 'No such key']
      end
    end

    def ping
      [:ok, :pong]
    end

    def sync(*_)
      [:err, 'Not implemented']
    end

    def type(name)
      if @collections.key? name
        [:ok, @collections[name][:type].to_s.gsub('Synergydb::Types::', '')]
      else
        [:err, 'No such key']
      end
    end

    def handle(command)
      method, = command

      if %w(ping get set create sync type).include? method
        begin
          send(*command)
        rescue Exception => e
          [:err, e]
        end
      else
        [:err, 'Unknown command']
      end
    end
  end
end
