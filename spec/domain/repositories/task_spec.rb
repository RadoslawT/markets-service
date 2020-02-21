# frozen_string_literal: true

describe Repositories::Task do
  let(:market) { create(:market) }
  let(:hit_task) do
    create(
      :task,
      market_uuid: market.uuid,
      completion_price: hit_task_completion_price,
      type: ValueObjects::TaskType::HIT
    )
  end
  let(:drop_task) do
    create(
      :task,
      market_uuid: market.uuid,
      completion_price: drop_task_completion_price,
      type: ValueObjects::TaskType::DROP
    )
  end
  let(:hit_task_completion_price) { market_entity.price.avrage * 2 }
  let(:drop_task_completion_price) { market_entity.price.avrage / 2 }

  let(:market_entity) { Entities::Market.from_repository(market.attributes) }
  let(:hit_task_entity) { Entities::Task.from_repository(hit_task.attributes) }
  let(:drop_task_entity) { Entities::Task.from_repository(drop_task.attributes) }

  let(:current_price) { ValueObjects::MarketPrice.new(ask: ask, bid: bid) }

  before do
    drop_task
    hit_task
  end

  describe '.tasks_to_complete' do
    subject(:find_by) do
      described_class.tasks_to_complete(market_uuid: market.uuid, past_price: market_entity.price, current_price: current_price)
    end

    context 'when price drops' do
      let(:ask) { drop_task_completion_price / 2 }
      let(:bid) { drop_task_completion_price / 2 }

      it { is_expected.to include(drop_task_entity) }
      it { is_expected.not_to include(hit_task_entity) }
    end

    context 'when price raises' do
      let(:ask) { hit_task_completion_price * 2 }
      let(:bid) { hit_task_completion_price * 2 }

      it { is_expected.to include(hit_task_entity) }
      it { is_expected.not_to include(drop_task_entity) }
    end
  end
end
