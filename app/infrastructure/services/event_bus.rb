# frozen_string_literal: true

module Services
  # :nodoc:
  class EventBus
    class << self
      def call(event:, topic:)
        DeliveryBoy.deliver_async({ name: event[:name], data: event[:params] }.to_json, topic: topic)
      end
    end
  end
end
