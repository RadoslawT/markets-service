# frozen_string_literal: true

module ValueObjects
  # :nodoc:
  class MarketPriceChange
    def initialize(market_uuid:, from:, to:)
      raise DomainErrors::IncorrectValueObject if from == to

      @market_uuid = market_uuid
      @from = from
      @to = to
      @type = from > to ? drop_type : hit_type
      freeze
    end

    attr_reader :market_uuid, :type, :to, :from

    def hit?
      type == hit_type
    end

    def drop?
      type == drop_type
    end

    def ==(other)
      market_uuid == other.market_uuid && to == other.to && type == other.type
    end

    private

    def hit_type
      ValueObjects::TaskType::HIT
    end

    def drop_type
      ValueObjects::TaskType::DROP
    end
  end
end
