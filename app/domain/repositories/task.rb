# frozen_string_literal: true

module Repositories
  # :nodoc:
  class Task < Repository
    @uow = UnitsOfWork::ActiveRecord
  end
end
