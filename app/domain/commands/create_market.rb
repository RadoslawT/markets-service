# frozen_string_literal: true

module Commands
  # :nodoc:
  class CreateMarket < Command
    validator do
      params do
        required(:platform).filled(:string)
        required(:name).filled(:string)
      end
    end
  end
end
