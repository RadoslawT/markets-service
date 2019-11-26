# frozen_string_literal: true

module DomainErrors
  class EntityExists < StandardError; end
  class EntityParamNotAllowed < StandardError; end
  class IncorrectValueObject < StandardError; end
  class DeleteCalledOnNewEntity < StandardError; end
end
