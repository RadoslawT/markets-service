# frozen_string_literal: true

# :nodoc:
class Repository
  class << self
    delegate :commit, to: :uow

    def adapt(entity)
      if entity.new?
        uow.created << entity
      elsif entity.deleted?
        uow.deleted << entity
      elsif entity.dirty?
        uow.updated << entity
      end
      self
    end

    def find_by(params)
      record = uow.find_by(entity_class, params)
      return unless record

      entity_class.from_repository(record)
    end

    def where(params)
      result = uow.where(entity_class, params)
      return [] if result.blank?

      result.map { |r| entity_class.from_repository(r) }
    end

    private

    def uow
      @uow || (raise InfrastructureErrors::UoWNotSpecified)
    end

    attr_writer :uow

    def entity_class
      name.sub('Repositories', 'Entities').constantize
    end
  end
end
