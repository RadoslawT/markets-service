# frozen_string_literal: true

module Commands
  # :nodoc:
  class UpdateMarketPrice < Command
    validator do
      params do
        required(:platform).value(type?: Symbol)
        required(:market_name).filled(:string)
        required(:ask_price).filled(:float)
        required(:bid_price).filled(:float)
      end
    end
  end
end
