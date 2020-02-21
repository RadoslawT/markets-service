# frozen_string_literal: true

module Handlers
  # :nodoc:
  class UpdateMarketPrice < Handler
    sidekiq_options queue: :default, retry: false

    REPOSITORY = Repositories::MarketWithTasksToComplete

    def call(params)
      current_price = ValueObjects::MarketPrice.new(ask: params[:ask_price], bid: params[:bid_price])

      market = REPOSITORY.find_by(
        platform: params[:platform],
        name: params[:market_name],
        current_price: current_price
      )
      return unless market

      update_market_price(market, current_price)
      nil
    end

    private

    def update_market_price(market, current_price)
      market.update_price(current_price: current_price)

      REPOSITORY.adapt(market).commit

      market.emit_task_completed_events
    end
  end
end
