# frozen_string_literal: true

module Entities
  # :nodoc:
  class Market < Entity
    attributes :id, :uuid, :platform, :name, :ask_price, :bid_price, :avrage_price, :created_at, :updated_at

    def self.create(params)
      price = ValueObjects::MarketPrice.new(ask: params[:ask_price], bid: params[:bid_price])

      new(
        uuid: SecureRandom.uuid,
        platform: ValueObjects::Platform.new(params[:platform]).value,
        name: params[:name],
        ask_price: price.ask,
        bid_price: price.bid,
        avrage_price: price.avrage
      )
    end

    def price
      @price ||= ValueObjects::MarketPrice.new(ask: ask_price, bid: bid_price)
    end

    def price=(market_price)
      @price = market_price
      @ask_price = market_price.ask
      @bid_price = market_price.bid
      @avrage_price = market_price.avrage
    end
  end
end
