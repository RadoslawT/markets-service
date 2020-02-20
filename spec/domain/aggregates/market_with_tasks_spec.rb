# frozen_string_literal: true

describe Aggregates::MarketWithTasks do
  let(:market_entity) { instance_double(Entities::Market, price: price, uuid: market_uuid) }
  let(:market_uuid) { double }
  let(:price) { 1.0 }

  before do
    allow(market_entity).to receive(:price=)
  end

  describe '.new' do
    subject(:market) { described_class.new(root: market_entity) }

    it { is_expected.to be_a_kind_of(described_class) }

    it 'has root' do
      expect(market.root).to eq(market_entity)
    end
  end

  describe '#add_task' do
    subject(:add_task) { aggregate.add_task(activation_price: activation_price, completion_price: completion_price) }

    let(:aggregate) { described_class.new(root: market_entity, tasks: tasks) }
    let(:activation_price) { 1.0 }
    let(:completion_price) { 2.0 }

    context 'when a similar task with the same completion_price and type already exists for this market' do
      let(:similar_task) do
        Entities::Task.create(
          market_uuid: market_uuid,
          activation_price: activation_price / 2,
          completion_price: completion_price
        )
      end
      let(:tasks) { [similar_task] }

      it 'does not create a new task' do
        expect { add_task }.not_to(change { aggregate.tasks.count })
      end
    end

    context 'when a similar task does not exist' do
      let(:tasks) { [] }

      it 'creates a new task' do
        expect { add_task }.to(change { aggregate.tasks.count }.from(0).to(1))
      end
    end
  end
end
