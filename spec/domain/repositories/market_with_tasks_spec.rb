# frozen_string_literal: true

describe Repositories::MarketWithTasks do
  let(:market) { create(:market) }
  let(:task) { create(:task, market_uuid: market.uuid) }

  let(:market_entity) { Entities::Market.from_repository(market.attributes) }
  let(:task_entity) { Entities::Task.from_repository(task.attributes) }

  describe '.find_by' do
    subject(:find_by) { described_class.find_by(name: market.name) }

    let(:market_uuid) { 'd52fbfee-7fb6-446a-bbc0-8d3ba476208f' }
    let(:trigger_price) { 1.0 }

    before { task }

    it { is_expected.to be_an(Aggregates::MarketWithTasks) }

    it 'returns correct market' do
      market_found = find_by
      expect(market_found.root).to eq(market_entity)
    end

    it 'returns correct tasks' do
      market_found = find_by
      expect(market_found.tasks).to include(task_entity)
    end
  end

  describe '.adapt' do
    subject(:adapt) { described_class.adapt(market_aggregate) }

    let(:market_aggregate) { Aggregates::MarketWithTasks.new(root: market_entity, tasks: [task_entity]) }

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
