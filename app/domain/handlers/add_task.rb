# frozen_string_literal: true

module Handlers
  # :nodoc:
  class AddTask < Handler
    sidekiq_options queue: :critical, retry: true

    def call(command:)
      market = Repositories::MarketWithTasks.find_by(uuid: command[:data][:market_uuid])
      return unless market

      market.add_task(
        activation_price: command[:data][:activation_price],
        completion_price: command[:data][:completion_price]
      )
      Repositories::MarketWithTasks.adapt(market).commit
      nil
    end
  end
end
