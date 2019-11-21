# frozen_string_literal: true

require 'dry-validation'

# Concern to validate input params with dry-validation
module Validator
  def validate(params)
    validator.new.call(params)
  end

  def validator(&block)
    @validator ||= Class.new Dry::Validation::Contract do
      instance_eval(&block)
    end
  end
end
