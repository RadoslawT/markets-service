# frozen_string_literal: true

module Queries
  # UserAlerts query returns list of Alert entites of given User
  class AllMarkets
    def self.call
      Repositories::Market.all
    end
  end
end
