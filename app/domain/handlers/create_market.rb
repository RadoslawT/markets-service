# frozen_string_literal: true

module Handlers
  # :nodoc:
  class CreateMarket < Handler
    sidekiq_options queue: :default, retry: true

    def call(command:)
      market = Repositories::Market.find_by(
        platform: command[:data][:platform],
        name: command[:data][:name]
      )
      return if market

      market = Entities::Market.create(platform: command[:data][:platform], name: command[:data][:name])

      Repositories::Market.adapt(market).commit

      nil
    end
  end
end
