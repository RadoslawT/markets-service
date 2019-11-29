# frozen_string_literal: true

FactoryBot.define do
  factory :task, class: 'UnitsOfWork::ActiveRecord::Task' do
    uuid             { SecureRandom.uuid }
    market_uuid      { create(:market).uuid }
    type             { ValueObjects::TaskType::HIT }
    completion_price { 1.23 }
  end
end
