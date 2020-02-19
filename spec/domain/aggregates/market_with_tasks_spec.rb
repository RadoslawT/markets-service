# frozen_string_literal: true

describe Aggregates::MarketWithTasks do
  let(:market_entity) { instance_double(Entities::Market, price: price, uuid: 'uuid') }
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
    let(:type) { 'type' }
    let(:activation_price) { 1 }
    let(:completion_price) { 2 }
    let(:new_task) do
      instance_double(
        Entities::Task,
        type: type,
        completion_price: completion_price,
        activation_price: activation_price,
        market_price_change: market_price_change
      )
    end
    let(:market_price_change) do
      ValueObjects::MarketPriceChange.new(
        market_uuid: market_entity.uuid,
        from: activation_price,
        to: completion_price
      )
    end

    before do
      allow(Entities::Task).to receive(:create).with(
        market_price_change: market_price_change
      ).and_return(new_task)
    end

    context 'when the same task already exists' do
      let(:tasks) do
        [
          instance_double(
            Entities::Task,
            type: new_task.type,
            completion_price: new_task.completion_price,
            activation_price: new_task.activation_price,
            market_price_change: new_task.market_price_change
          )
        ]
      end

      it 'does not create a new task' do
        add_task
        expect(aggregate.tasks).not_to include(new_task)
      end
    end

    context 'when the same task does not exist' do
      let(:tasks) { [] }

      it 'creates a new task' do
        add_task
        expect(aggregate.tasks).to include(new_task)
      end
    end
  end
end
