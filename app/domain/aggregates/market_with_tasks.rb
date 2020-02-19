# frozen_string_literal: true

module Aggregates
  # :nodoc:
  class MarketWithTasks
    attr_reader :root, :tasks

    def initialize(root:, tasks: [])
      @root = root
      @tasks = tasks
    end

    def add_task(activation_price:, completion_price:)
      market_price_change = ValueObjects::MarketPriceChange.new(
        market_uuid: root.uuid,
        from: activation_price,
        to: completion_price
      )
      return if task_exists?(market_price_change)

      @tasks << Entities::Task.create(market_price_change: market_price_change)
      nil
    end

    private

    def task_exists?(market_price_change)
      @tasks.select { |t| t.market_price_change == market_price_change }.any?
    end
  end
end
