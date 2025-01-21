require 'async/websocket/adapters/rails'

class HomeController < ApplicationController
  def index
    self.response = Async::WebSocket::Adapters::Rails.open(request) do |connection|
      loop do
        channel = connection.read.to_str.chomp

        subscribe(channel) do |context|
          Console.info(connection, "Subscribed", channel: channel)

          loop do
            event = context.listen
            Protocol::WebSocket::TextMessage.generate(event).send(connection)
            connection.flush
          end
        end
      end
    end
  end

  private

  def subscribe(channel, &block)
    client.subscribe(channel, &block)
  end

  def client(endpoint: Async::Redis.local_endpoint)
    @client ||= Async::Redis::Client.new(endpoint)
  end
end
