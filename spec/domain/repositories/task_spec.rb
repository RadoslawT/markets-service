# frozen_string_literal: true

describe Repositories::Task do
  let(:market) { create(:market) }
  let(:hit_task) { create(:task, market_uuid: market.uuid, completion_price: market.price * 2, type: ValueObjects::TaskType::HIT) }
  let(:drop_task) { create(:task, market_uuid: market.uuid, completion_price: market.price / 2, type: ValueObjects::TaskType::DROP) }

  let(:market_entity) { Entities::Market.from_repository(market.attributes) }
  let(:hit_task_entity) { Entities::Task.from_repository(hit_task.attributes) }
  let(:drop_task_entity) { Entities::Task.from_repository(drop_task.attributes) }

  describe '.tasks_to_complete' do
    subject(:find_by) { described_class.tasks_to_complete(market_uuid: market.uuid, market_price: market.price, new_price: new_price) }

    context 'when price drops' do
      let(:new_price) { drop_task.completion_price / 2 }

      it { is_expected.to include(drop_task_entity) }
      it { is_expected.not_to include(hit_task_entity) }
    end

    context 'when price raises' do
      let(:new_price) { hit_task.completion_price * 2 }

      it { is_expected.to include(hit_task_entity) }
      it { is_expected.not_to include(drop_task_entity) }
    end
  end
end
