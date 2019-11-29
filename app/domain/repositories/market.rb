# frozen_string_literal: true

module Repositories
  # :nodoc:
  class Market < Repository
    @uow = UnitsOfWork::ActiveRecord
  end
end
