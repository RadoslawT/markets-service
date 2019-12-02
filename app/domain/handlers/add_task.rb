# frozen_string_literal: true

module Handlers
  # :nodoc:
  class AddTask < Handler
    sidekiq_options queue: :default, retry: true

    def call(command:)
      market = Repositories::MarketAggregate.find_by(uuid: command[:data][:market_uuid])
      return unless market

      market.add_task(
        completion_price: command[:data][:completion_price],
        type: command[:data][:type].to_sym
      )

      Repositories::MarketAggregate.adapt(market).commit
      nil
    end
  end
end
