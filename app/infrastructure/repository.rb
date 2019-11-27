# frozen_string_literal: true

# :nodoc:
class Repository
  class << self
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

    def commit
      uow.commit
      self
    end

    def find_by(params)
      record = uow.find_by(entity_class, params)
      return unless record

      entity_class.from_repository(record)
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
