# frozen_string_literal: true

module UnitsOfWork
  # :nodoc:
  class ActiveRecord < UnitOfWork
    def serialized
      attributes.symbolize_keys
    end

    class << self
      def find_by(entity_class, params)
        klass(entity_class).find_by(params)&.attributes
      end

      def create(entity)
        klass(entity.class).create!(entity.attributes)
      end

      def update(entity)
        klass(entity.class).update(entity.id, **entity.attributes)
      end

      def delete(entity)
        klass(entity.class).delete entity.id
      end

      def transaction
        ::ActiveRecord::Base.transaction do
          yield
        end
      end

      private

      def klass(entity_class)
        entity_class_name = entity_class.name.demodulize
        "::UnitsOfWork::ActiveRecord::#{entity_class_name}".constantize
      end
    end

    class Market < ::ActiveRecord::Base; end
    class MarketTask < ::ActiveRecord::Base; end
  end
end
