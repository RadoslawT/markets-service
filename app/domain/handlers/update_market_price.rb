# frozen_string_literal: true

module Handlers
  # :nodoc:
  class UpdateMarketPrice < Handler
    sidekiq_options queue: :default, retry: false
    def call(command:)
      puts command.inspect
    end
  end
end
