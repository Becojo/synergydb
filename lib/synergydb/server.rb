require 'socket'
require 'thread'
require 'json'

require 'synergydb/database'

module Synergydb
  class Server
    attr_reader :host, :port

    def initialize(host = '127.0.0.1', port = 1234)
      @host = host
      @port = port
      @database = Database.new
      @socket = nil
      @client_count = 0
      @threads = []
    end

    def start
      @running = true
      @socket = TCPServer.new(@host, @port)

      loop do
        @threads << Thread.start(@socket.accept) do |client|
          handle_client(client)
        end
      end
    end

    def kill
      @threads.each do |thread|
        thread.kill
      end
    end

    private

    def handle_client(client)
      loop do
        begin
          command = JSON.parse(client.gets)

          client.puts @database.handle(command).to_json
        rescue Exception => e
          client.puts [:err, e].to_json
        end
      end
    end
  end
end
