# frozen_string_literal: true

module Services
  # :nodoc:
  class CreateBittrexMarkets
    include Sidekiq::Worker
    sidekiq_options queue: :low, retry: true

    def self.call
      markets = Adapters::BittrexApi.markets_tickers

      markets.each do |market|
        Commands::CreateMarket.call(platform: ValueObjects::Platform::BITTREX, name: market[:symbol])
      end

      nil
    end

    def perform
      self.class.call
    end
  end
end
