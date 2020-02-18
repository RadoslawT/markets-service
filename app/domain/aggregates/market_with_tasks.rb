# frozen_string_literal: true

module Aggregates
  # :nodoc:
  class MarketWithTasks
    attr_reader :root, :tasks

    def initialize(root:, tasks: [])
      @root = root
      @tasks = tasks
    end

    def add_task(type:, completion_price:)
      return if task_exists?(type, completion_price)

      @tasks << Entities::Task.create(
        market_uuid: root.uuid,
        completion_price: completion_price,
        type: type
      )
      nil
    end

    private

    def task_exists?(type, completion_price)
      @tasks.select { |t| t.type == type && t.completion_price == completion_price }.any?
    end
  end
end
