# frozen_string_literal: true

module Services
  # :nodoc:
  class UpdateBittrexMarketsPrices
    include Sidekiq::Worker
    sidekiq_options queue: :low, retry: false

    def self.call
      markets = Adapters::BittrexApi.markets_tickers

      markets.each do |market|
        Commands::UpdateMarketPrice.call(
          platform: ValueObjects::Platform::BITTREX,
          market_name: market[:symbol],
          ask_price: market[:ask_rate],
          bid_price: market[:bid_rate]
        )
      end
    end

    def perform
      self.class.call
    end
  end
end
