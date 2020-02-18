# frozen_string_literal: true

module Repositories
  # :nodoc:
  class MarketWithTasks < Repository
    @uow = UnitsOfWork::ActiveRecord

    class << self
      def find_by(params)
        market = Market.find_by(params)
        return unless market

        tasks = Task.where(market_uuid: market.uuid)

        Aggregates::MarketWithTasks.new(root: market, tasks: tasks)
      end

      def adapt(market)
        Market.adapt(market.root)
        market.tasks.each { |t| Task.adapt(t) }
        self
      end
    end
  end
end
