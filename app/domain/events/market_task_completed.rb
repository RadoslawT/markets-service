# frozen_string_literal: true

module Events
  # :nodoc:
  class MarketTaskCompleted < Event
    @topic = 'market-task-completed'

    validator do
      params do
        required(:market_uuid).filled(:string)
        required(:completion_price).filled(:float)
        required(:type).filled(:string)
      end
    end
  end
end
