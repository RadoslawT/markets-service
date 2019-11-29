# frozen_string_literal: true

# :nodoc:
class UnitOfWork
  def serialized
    raise NotImplementedError
  end

  class << self
    def find_by(_params)
      raise NotImplementedError
    end

    def where(_params)
      raise NotImplementedError
    end

    def commit
      transaction do
        created.each { |e| create(e) }.clear
        updated.each { |e| update(e) }.clear
        deleted.each { |e| delete(e) }.clear
      end
      nil
    end

    def create(_entity)
      raise NotImplementedError
    end

    def update(_entity)
      raise NotImplementedError
    end

    def delete(_entity)
      raise NotImplementedError
    end

    def transaction
      raise NotImplementedError
    end

    def created
      @created ||= []
    end

    def updated
      @updated ||= []
    end

    def deleted
      @deleted ||= []
    end
  end
end
