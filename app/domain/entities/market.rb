# frozen_string_literal: true

module Entities
  # :nodoc:
  class Market < Entity
    params :id, :uuid, :platform, :name, :price, :created_at, :updated_at

    attr_writer :price

    def self.create(params)
      new(
        uuid: SecureRandom.uuid,
        platform: ValueObjects::Platform.new(params[:platform]).value,
        name: params[:name],
        price: params[:price]
      )
    end
  end
end
