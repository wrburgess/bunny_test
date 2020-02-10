class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    connection = Bunny.new
    connection.start

    channel = connection.create_channel
    queue  = channel.queue("bunny.examples.hello_world", auto_delete: true)
    exchange = channel.default_exchange

    queue.subscribe do |delivery_info, metadata, payload|
      puts "delivery_info: #{delivery_info}, metadata: #{metadata}, payload: #{metadata}"
    end

    exchange.publish("Hello!", routing_key: queue.name)

    sleep 1.0
    connection.close

    { stuff: "yalp" }
  end
end
