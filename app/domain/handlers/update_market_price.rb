# frozen_string_literal: true

module Handlers
  # :nodoc:
  class UpdateMarketPrice < Handler
    sidekiq_options queue: :default, retry: false
    def call(command:)
      market = Repositories::MarketWithTasks.find_by(
        platform: command[:data][:platform],
        name: command[:data][:market_name]
      )
      return unless market

      market.update_price(price: command[:data][:market_price])

      Repositories::MarketWithTasks.adapt(market).commit

      market.emit_task_completed_events
      nil
    end
  end
end
