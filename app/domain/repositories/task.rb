# frozen_string_literal: true

module Repositories
  # :nodoc:
  class Task < Repository
    @uow = UnitsOfWork::ActiveRecord

    class << self
      def tasks_to_complete(market_uuid:, past_price:, current_price:)
        if past_price.avrage > current_price.avrage
          drop_tasks_to_complete(market_uuid, current_price.avrage)
        else
          hit_tasks_to_complete(market_uuid, current_price.avrage)
        end
      end

      private

      def drop_tasks_to_complete(market_uuid, current_price)
        where(
          market_uuid: market_uuid,
          type: ValueObjects::TaskType::DROP,
          completion_price: current_price..Float::INFINITY
        )
      end

      def hit_tasks_to_complete(market_uuid, current_price)
        where(
          market_uuid: market_uuid,
          type: ValueObjects::TaskType::HIT,
          completion_price: -Float::INFINITY..current_price
        )
      end
    end
  end
end
