# frozen_string_literal: true

module Aggregates
  # :nodoc:
  class MarketWithTasksToComplete
    attr_reader :root, :tasks

    def initialize(root:, tasks: [])
      @root = root
      @tasks = tasks
    end

    def update_price(price:)
      return if @root.price == price

      tasks_to_complete = if price < @root.price
                            drop_tasks(price)
                          else
                            hit_tasks(price)
                          end

      tasks_to_complete.each(&:complete)

      @root.price = price
      nil
    end

    def emit_task_completed_events
      completed_tasks.each { |t| emit_task_completed_event(t) }
    end

    private

    def drop_tasks(price)
      @tasks.select { |t| t.type_drop? && t.completion_price >= price }
    end

    def hit_tasks(price)
      @tasks.select { |t| t.type_hit? && t.completion_price <= price }
    end

    def completed_tasks
      @tasks.select(&:completed?)
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
