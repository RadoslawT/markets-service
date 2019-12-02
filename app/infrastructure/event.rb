# frozen_string_literal: true

# :nodoc:
class Event
  extend ::Validator

  class << self
    def call(params = {})
      result = validate(params.compact)

      raise InfrastructureErrors::EventInvalid unless result.success?

      emit(params)
      nil
    end

    private

    attr_reader :topic

    def emit(params)
      Services::EventBus.call(event: { name: event_name, params: params }, topic: topic)
    end

    def event_name
      name.demodulize.underscore
    end
  end
end
