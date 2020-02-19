# frozen_string_literal: true

module Commands
  # :nodoc:
  class AddTask < Command
    validator do
      params do
        required(:market_uuid).filled(:string)
        required(:completion_price).filled(:float)
        required(:activation_price).filled(:float)
      end
    end
  end
end
