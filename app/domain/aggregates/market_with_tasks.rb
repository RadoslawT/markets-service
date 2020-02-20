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
      task = Entities::Task.create(
        market_uuid: root.uuid,
        activation_price: activation_price,
        completion_price: completion_price
      )
      return if same_task_exists?(task)

      @tasks << task
      nil
    end

    private

    def same_task_exists?(task)
      @tasks.select { |t| t.same_as?(task) }.any?
    end
  end
end
