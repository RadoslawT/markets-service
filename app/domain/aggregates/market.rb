# frozen_string_literal: true

module Aggregates
  # :nodoc:
  class Market
    attr_reader :root

    def initialize(root:)
      @root = root
    end

    def update_price(price)
      @root.price = price
    end
  end
end
