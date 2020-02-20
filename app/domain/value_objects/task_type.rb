# frozen_string_literal: true

module ValueObjects
  # :nodoc:
  class TaskType
    DROP = :drop
    HIT  = :hit
    TYPES = [DROP, HIT].freeze

    def initialize(activation_price:, completion_price:)
      raise DomainErrors::IncorrectValueObject if activation_price == completion_price

      @value = type(activation_price, completion_price)
      freeze
    end

    attr_reader :value

    private

    def type(activation_price, completion_price)
      activation_price > completion_price ? DROP : HIT
    end
  end
end
