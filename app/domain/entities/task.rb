# frozen_string_literal: true

module Entities
  # :nodoc:
  class Task < Entity
    params :id, :uuid, :market_uuid, :activation_price, :completion_price, :type, :created_at, :updated_at

    attr_writer :price

    def self.create(params)
      price_change = params[:market_price_change]

      new(
        uuid: SecureRandom.uuid,
        market_uuid: price_change.market_uuid,
        type: price_change.type,
        activation_price: price_change.from,
        completion_price: price_change.to
      )
    end

    def complete
      delete
    end

    def completed?
      deleted?
    end

    def market_price_change
      @market_price_change ||= ValueObjects::MarketPriceChange.new(
        market_uuid: market_uuid,
        from: activation_price,
        to: completion_price
      )
    end

    def ==(other)
      completion_price == other.completion_price && type == other.type && market_uuid == other.market_uuid
    end
  end
end
