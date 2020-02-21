# frozen_string_literal: true

FactoryBot.define do
  factory :market, class: 'UnitsOfWork::ActiveRecord::Market' do
    uuid          { SecureRandom.uuid }
    ask_price     { 1.0 }
    bid_price     { 2.0 }
    avrage_price  { 1.5 }
    platform      { ValueObjects::Platform::BITTREX }
    sequence :name do |n|
      "test#{n}"
    end
  end
end
