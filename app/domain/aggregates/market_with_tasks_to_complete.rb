# frozen_string_literal: true

module Aggregates
  # :nodoc:
  class MarketWithTasksToComplete
    attr_reader :root, :tasks_to_complete

    def initialize(root:, tasks_to_complete: [])
      @root = root
      @tasks_to_complete = tasks_to_complete
    end

    def update_price(price:)
      return if @root.price == price

      @tasks_to_complete.each(&:complete)

      @root.price = price
      nil
    end

    def emit_task_completed_events
      completed_tasks.each { |t| emit_task_completed_event(t) }
    end

    private

    def completed_tasks
      @tasks_to_complete.select(&:completed?)
    end

    def emit_task_completed_event(task)
      Events::MarketTaskCompleted.call(
        market_uuid: task.market_uuid,
        completion_price: task.completion_price,
        type: task.type.to_s
      )
    end
  end
end
