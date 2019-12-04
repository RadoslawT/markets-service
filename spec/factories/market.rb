# frozen_string_literal: true

FactoryBot.define do
  factory :market, class: 'UnitsOfWork::ActiveRecord::Market' do
    uuid     { SecureRandom.uuid }
    price    { 1.0 }
    platform { ValueObjects::Platform::BITTREX }
    sequence :name do |n|
      "test#{n}"
    end
  end
end
