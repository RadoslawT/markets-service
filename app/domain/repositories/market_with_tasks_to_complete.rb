# frozen_string_literal: true

module Repositories
  # :nodoc:
  class MarketWithTasksToComplete < Repository
    @uow = UnitsOfWork::ActiveRecord

    class << self
      def find_by(new_price:, **params)
        market = Market.find_by(params)
        return unless market

        tasks_to_complete = Repositories::Task.tasks_to_complete(
          market_uuid: market.uuid,
          market_price: market.price,
          new_price: new_price
        )

        Aggregates::MarketWithTasksToComplete.new(root: market, tasks_to_complete: tasks_to_complete)
      end

      def adapt(market)
        Market.adapt(market.root)
        market.tasks_to_complete.each { |t| Task.adapt(t) }
        self
      end
    end
  end
end
