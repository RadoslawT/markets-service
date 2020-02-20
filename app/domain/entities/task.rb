# frozen_string_literal: true

module Entities
  # :nodoc:
  class Task < Entity
    DROP = ValueObjects::TaskType::DROP
    HIT  = ValueObjects::TaskType::HIT

    params :id, :uuid, :market_uuid, :activation_price, :completion_price, :type, :created_at, :updated_at

    attr_writer :price

    def self.create(params)
      new(
        uuid: SecureRandom.uuid,
        market_uuid: params[:market_uuid],
        activation_price: params[:activation_price],
        completion_price: params[:completion_price],
        type: type(params[:activation_price], params[:completion_price])
      )
    end

    def self.type(activation_price, completion_price)
      activation_price > completion_price ? DROP : HIT
    end

    def complete
      delete
    end

    def completed?
      deleted?
    end

    def same_as?(other)
      completion_price == other.completion_price && type == other.type && market_uuid == other.market_uuid
    end
  end
end
