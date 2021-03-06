# frozen_string_literal: true

module InfrastructureErrors
  class BadResponse < StandardError; end
  class CommandInvalid < StandardError; end
  class EventInvalid < StandardError; end
end
