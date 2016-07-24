require 'synergydb/types'
require 'json'

module Synergydb
  class Client
    def initialize(host = '127.0.0.1', port = 1234)
      @socket = TCPSocket.open(host, port)
    end

    def get(*args)
      send_command('get', args)
    end

    def set(*args)
      send_command('set', args)
    end

    def create(*args)
      send_command('create', args)
    end

    def ping
      send_command('ping')
    end

    def type(key)
      send_command('type', [key])
    end

    def close
      @socket.close
    end

    private

    def send_command(command, args = [])
      json = ([command] + args).to_json

      @socket.puts(json)

      JSON.parse(@socket.gets)
    end
  end

end
