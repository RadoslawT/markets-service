# frozen_string_literal: true

module Handlers
  # :nodoc:
  class UpdateMarketPrice < Handler
    sidekiq_options queue: :default, retry: false
    def call(command:)
      market = Repositories::MarketAggregate.find_by(
        platform: command[:data][:platform],
        name: command[:data][:market_name]
      )

      return unless market

      market.update_price(command[:data][:market_price])

      Repositories::MarketAggregate.adapt(market).commit

      nil
    end
  end
end
