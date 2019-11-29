# frozen_string_literal: true

module Entities
  # :nodoc:
  class Task < Entity
    params :id, :uuid, :market_uuid, :type, :completion_price, :created_at, :updated_at

    attr_writer :price

    def self.create(params)
      task_type = ValueObjects::TaskType.new(params[:type])

      new(
        uuid: SecureRandom.uuid,
        market_uuid: params[:market_uuid],
        type: task_type.value,
        completion_price: params[:completion_price]
      )
    end
  end
end
