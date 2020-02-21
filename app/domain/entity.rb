# frozen_string_literal: true

# :nodoc:
class Entity
  # Class methods
  class << self
    private_class_method :new

    def create
      raise NotImplementedError
    end

    def from_repository(attributes)
      new(attributes.symbolize_keys, new_entity: false)
    end

    def attributes(*attributes)
      return @attributes if @attributes

      @attributes = attributes
      attributes.each { |attribute| attr_reader attribute }
    end
  end

  # Instance methods

  # Returns hash of attributes { attribue_a: value_a, attribute_b: value_b}
  def attributes
    instance_values.symbolize_keys.slice(*self.class.attributes)
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

  private

  def initialize(attributes, new_entity: true)
    attributes.each do |attribute, value|
      raise DomainErrors::EntityAttributeNotAllowed, "attribute: #{attribute}" unless self.class.attributes.include?(attribute)

      instance_variable_set(:"@#{attribute}", value)
    end

    @new_entity = new_entity
    @deleted = false
    @initialize_attributes = attributes
  end

  attr_reader :initialize_attributes, :deleted, :new_entity
end
