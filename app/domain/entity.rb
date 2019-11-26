# frozen_string_literal: true

# :nodoc:
class Entity
  def attributes
    instance_values.symbolize_keys.slice(*self.class.allowed_params)
  end

  def dirty?
    !new? && !deleted? && initialize_attributes != attributes
  end

  def new?
    new_entity
  end

  def deleted?
    deleted
  end

  def delete
    raise DomainErrors::DeleteCalledOnNewEntity if new?

    @deleted = true
  end

  def ==(other)
    attributes == other.attributes && self.class.name == other.class.name
  end

  class << self
    attr_reader :allowed_params

    def create
      raise NotImplementedError
    end

    def from_repository(serialized_result)
      new(serialized_result.symbolize_keys, new_entity: false)
    end

    def params(*params)
      params.each { |param| attr_reader param }
      @allowed_params = params
    end
  end

  private

  def initialize(params, new_entity: true)
    params.each do |param, value|
      raise DomainErrors::EntityParamNotAllowed, "param: #{param}" unless self.class.allowed_params.include?(param)

      instance_variable_set(:"@#{param}", value)
    end

    @new_entity = new_entity
    @deleted = false
    @initialize_attributes = attributes
  end

  attr_reader :initialize_attributes, :deleted, :new_entity

  private_class_method :new
end
