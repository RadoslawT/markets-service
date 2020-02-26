# frozen_string_literal: true

module Handlers
  # :nodoc:
  class CreateMarket < Handler
    sidekiq_options queue: :critical, retry: true

    def call(params)
      market = Repositories::Market.find_by(
        platform: params[:platform],
        name: params[:name]
      )
      return if market

      market = Entities::Market.create(
        platform: params[:platform].to_sym,
        name: params[:name],
        ask_price: params[:ask_price],
        bid_price: params[:bid_price]
      )
      Repositories::Market.adapt(market).commit

      nil
    end
  end
end
