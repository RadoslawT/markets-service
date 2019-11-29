# frozen_string_literal: true

# :nodoc:
class Consumer < Racecar::Consumer
  def process(message)
    data = JSON.parse(message.value).deep_symbolize_keys
    call(data)
  rescue JSON::ParserError => e
    puts "Failed to process message in #{message.topic}/#{message.partition} at offset #{message.offset}: #{e}"
    # It's probably a good idea to report the exception to an exception tracker service.
  end

  def self.topic(topic_name)
    subscribes_to(topic_name)
  end
end
