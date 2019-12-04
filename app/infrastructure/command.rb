# frozen_string_literal: true

# Command base class
class Command
  extend ::Validator

  def self.call(params = {})
    params = params.compact

    validate(params).tap do |result|
      new(params).call if result.success?
    end
  end

  def initialize(params)
    @params = params
  end

  def call
    Services::CommandBus.call(command_name: name, data: params)
  end

  private

  attr_reader :params

  def name
    self.class.name
  end
end
