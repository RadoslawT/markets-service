# frozen_string_literal: true

module Serializers
  # :nodoc:
  class Market < JSONAPI::Serializable::Resource
    type 'markets'

    id { @object.uuid }

    attributes :name, :platform
  end
end
