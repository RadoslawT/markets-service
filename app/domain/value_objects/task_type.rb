# frozen_string_literal: true

module ValueObjects
  # :nodoc:
  class TaskType
    DROP = :drop
    HIT  = :hit
    TYPES = [DROP, HIT].freeze

    def initialize(task_type)
      raise DomainErrors::IncorrectValueObject unless TYPES.include?(task_type)

      @value = task_type
      freeze
    end

    attr_reader :value
  end
end
