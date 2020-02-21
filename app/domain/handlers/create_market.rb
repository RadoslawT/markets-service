# frozen_string_literal: true

module Handlers
  # :nodoc:
  class CreateMarket < Handler
    sidekiq_options queue: :default, retry: true

    def call(params)
      market = Repositories::Market.find_by(
        platform: params[:platform],
        name: params[:name]
      )
      return if market

      market = Entities::Market.create(platform: params[:platform], name: params[:name])

      Repositories::Market.adapt(market).commit

      nil
    end
  end
end
