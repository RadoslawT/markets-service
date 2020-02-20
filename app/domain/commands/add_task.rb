# frozen_string_literal: true

module Commands
  # :nodoc:
  class AddTask < Command
    validator do
      params do
        required(:market_uuid).filled(:string)
        required(:activation_price).filled(:float)
        required(:completion_price).filled(:float)
      end

      rule(:activation_price, :completion_price) do
        key.failure('must be diffrent than completion_price') if values[:activation_price] == values[:completion_price]
      end
    end
  end
end
