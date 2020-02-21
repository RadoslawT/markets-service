# frozen_string_literal: true

module Handlers
  # :nodoc:
  class AddTask < Handler
    sidekiq_options queue: :critical, retry: true

    def call(params)
      market = Repositories::MarketWithTasks.find_by(uuid: params[:market_uuid])
      return unless market

      market.add_task(
        activation_price: params[:activation_price],
        completion_price: params[:completion_price]
      )
      Repositories::MarketWithTasks.adapt(market).commit
      nil
    end
  end
end
