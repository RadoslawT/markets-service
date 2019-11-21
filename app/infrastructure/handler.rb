# frozen_string_literal: true

# :nodoc:
class Handler
  include Sidekiq::Worker

  def self.call(command:)
    perform_async(command: command)
  end

  def perform(params)
    call(command: params[:command])
  end
end
