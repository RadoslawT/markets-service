# frozen_string_literal: true

module Consumers
  # :nodoc:
  class AlertSet < Consumer
    topic 'alerts-alert'

    def call(event)
      return if event[:name] != 'alert_set'
      return if event[:data][:activation_price] == event[:data][:trigger_price]

      Commands::AddTask.call(
        market_uuid: event[:data][:market_uuid],
        completion_price: event[:data][:trigger_price],
        activation_price: event[:data][:activation_price]
      )

      nil
    end
  end
end
