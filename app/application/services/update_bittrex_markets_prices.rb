# frozen_string_literal: true

module Services
  # :nodoc:
  class UpdateBittrexMarketsPrices
    include Sidekiq::Worker
    sidekiq_options queue: :low, retry: false

    def self.call
      markets = Adapters::BittrexApi.markets_tickers

      markets.each do |market|
        price = (market[:ask_rate] + market[:bid_rate]) / 2.0
        Commands::UpdateMarketPrice.call(platform: 'bittrex', market_name: market[:symbol], market_price: price)
      end
    end

    def perform
      self.class.call
    end
  end
end
