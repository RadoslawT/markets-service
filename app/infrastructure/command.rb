# frozen_string_literal: true

# Command base class
class Command
  extend ::Validator

  def self.call(params = {})
    command = new

    result = validate(params.compact)

    command.request_execution(params) if result.success?

    result
  end

  def request_execution(params)
    Services::CommandBus.call(command_name: command_name, data: params)
  end

  private

  def command_name
    self.class.name
  end
end
