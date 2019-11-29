# frozen_string_literal: true

module Consumers
  # :nodoc:
  class AlertSet < Consumer
    topic 'alerts-alert'

    def call(event)
      return unless event[:name] == 'alert_set'

      activation_price = event[:data][:activation_price]
      completion_price = event[:data][:trigger_price]
      market_uuid      = event[:data][:market_uuid]

      return if activation_price == completion_price

      Commands::AddTask.call(
        market_uuid: market_uuid,
        completion_price: completion_price,
        type: task_type(completion_price, activation_price)
      )
      nil
    end

    private

    def task_type(completion_price, activation_price)
      completion_price < activation_price ? drop_type : hit_type
    end

    def hit_type
      ValueObjects::TaskType::HIT
    end

    def drop_type
      ValueObjects::TaskType::DROP
    end
  end
end
