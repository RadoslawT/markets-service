# frozen_string_literal: true

namespace :markets do
  desc 'Create jobs with market creation task for Bittrex platform'

  task create: :environment do
    Services::CreateBittrexMarkets.call
  end
end
