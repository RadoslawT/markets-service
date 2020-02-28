# frozen_string_literal: true

module Services
  # :nodoc:
  class CreateBittrexMarkets
    def self.call
      markets = Adapters::BittrexApi.markets_tickers

      markets.each do |market|
        Commands::CreateMarket.call(
          platform: ValueObjects::Platform::BITTREX,
          name: market[:symbol],
          ask_price: market[:ask_rate],
          bid_price: market[:bid_rate]
        )
      end

      nil
    end
  end
end
