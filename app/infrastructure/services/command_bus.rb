# frozen_string_literal: true

# Forwards Commands to Handlers

module Services
  # :nodoc:
  class CommandBus
    extend ::Validator

    validator do
      params do
        required(:data).value(:hash)
        required(:command_name).filled(:string)
      end
    end

    def self.call(command)
      result = validate(command)
      raise InfrastructureErrors::CommandInvalid unless result.success?

      new(command).process
    end

    def initialize(command)
      @command = command
      @command_name = command[:command_name]
    end

    def process
      handler_class.call(command: command)
    end

    private

    attr_reader :command, :command_name

    def handler_class
      command_name.sub('Commands', 'Handlers').constantize
    end
  end
end
