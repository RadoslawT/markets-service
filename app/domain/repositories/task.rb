# frozen_string_literal: true

module Repositories
  # :nodoc:
  class Task < Repository
    @uow = UnitsOfWork::ActiveRecord

    class << self
      def tasks_to_complete(market_uuid:, market_price:, new_price:)
        if new_price < market_price
          drop_tasks_to_complete(market_uuid, new_price)
        else
          hit_tasks_to_complete(market_uuid, new_price)
        end
      end

      private

      def drop_tasks_to_complete(market_uuid, new_price)
        where(market_uuid: market_uuid, type: ValueObjects::TaskType::DROP, completion_price: new_price..Float::INFINITY)
      end

      def hit_tasks_to_complete(market_uuid, new_price)
        where(market_uuid: market_uuid, type: ValueObjects::TaskType::HIT, completion_price: -Float::INFINITY..new_price)
      end
    end
  end
end
