# frozen_string_literal: true

module ValueObjects
  # :nodoc:
  class Platform
    BITTREX = 'bittrex'
    PLATFORMS = [BITTREX].freeze

    def initialize(platform)
      raise DomainErrors::IncorrectValueObject unless PLATFORMS.include?(platform)

      @value = platform
      freeze
    end

    attr_reader :value
  end
end
