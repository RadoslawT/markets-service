# frozen_string_literal: true

FactoryBot.define do
  factory :task, class: 'UnitsOfWork::ActiveRecord::Task' do
    uuid             { SecureRandom.uuid }
    market_uuid      { create(:market).uuid }
    type             { ValueObjects::TaskType::HIT }
    activation_price { 1.00 }
    completion_price { 2.00 }
  end
end
