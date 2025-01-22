require 'async'
require 'async/redis'

endpoint = Async::Redis.local_endpoint
client = Async::Redis::Client.new(endpoint)

Async do
  (0..).each do |i|
    channel = i.even? ? 'ch01' : 'ch02'
    client.publish(channel, "message#{i}")
    sleep 1
  end
end
