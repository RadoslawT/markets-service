# frozen_string_literal: true

module Repositories
  # Alert Repository interface
  class MarketAggregate < Repository
    @uow = UnitsOfWork::ActiveRecord

    class << self
      def find_by(params)
        market = Market.find_by(params)
        return unless market

        Aggregates::Market.new(root: market)
      end

      def adapt(aggregate)
        Market.adapt(aggregate.root)
        self
      end
    end
  end
end
