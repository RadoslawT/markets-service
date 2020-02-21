# frozen_string_literal: true

module ValueObjects
  # :nodoc:
  class MarketPrice
    def initialize(ask:, bid:)
      raise DomainErrors::IncorrectValueObject if ask <= 0 || bid <= 0

      @ask = ask
      @bid = bid
      @avrage = (ask + bid) / 2.0

      freeze
    end

    attr_reader :ask, :bid, :avrage

    def ==(other)
      ask == other.ask && bid == other.ask && avrage == other.avrage
    end
  end
end
