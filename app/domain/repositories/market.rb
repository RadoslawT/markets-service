# frozen_string_literal: true

module Repositories
  # Alert Repository interface
  class Market < Repository
    @uow = UnitsOfWork::ActiveRecord
  end
end
