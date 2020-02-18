# frozen_string_literal: true

describe Repositories::MarketWithTasksToComplete do
  let(:market) { create(:market) }
  let(:task) { create(:task, market_uuid: market.uuid) }

  let(:market_entity) { Entities::Market.from_repository(market.attributes) }
  let(:task_entity) { Entities::Task.from_repository(task.attributes) }

  describe '.find_by' do
    subject(:find_by) { described_class.find_by(new_price: new_price, name: market.name) }

    let(:market_uuid) { 'd52fbfee-7fb6-446a-bbc0-8d3ba476208f' }
    let(:new_price) { double }
    let(:tasks_to_complete) { double }

    before do
      task
      allow(Repositories::Task).to receive(:tasks_to_complete).with(
        market_uuid: market.uuid,
        market_price: market.price,
        new_price: new_price
      ).and_return(tasks_to_complete)
    end

    it { is_expected.to be_an(Aggregates::MarketWithTasksToComplete) }

    it 'returns correct market' do
      market_found = find_by
      expect(market_found.root).to eq(market_entity)
    end

    it 'returns correct tasks' do
      market_found = find_by
      expect(market_found.tasks_to_complete).to eq(tasks_to_complete)
    end
  end

  describe '.adapt' do
    subject(:adapt) { described_class.adapt(market_aggregate) }

    let(:market_aggregate) { Aggregates::MarketWithTasksToComplete.new(root: market_entity, tasks_to_complete: [task_entity]) }

    before do
      allow(Repositories::Market).to receive(:adapt)
      allow(Repositories::Task).to receive(:adapt)
    end

    it 'adapts Market root' do
      adapt
      expect(Repositories::Market).to have_received(:adapt).with(market_entity)
    end

    it 'adapts Tasks' do
      adapt
      expect(Repositories::Task).to have_received(:adapt).with(task_entity)
    end
  end
end
