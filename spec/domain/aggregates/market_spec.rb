# frozen_string_literal: true

describe Aggregates::Market do
  let(:market_entity) { instance_double(Entities::Market, price: price) }
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

  describe '#update_price' do
    subject(:update_price) { aggregate.update_price(new_price) }

    let(:aggregate) { described_class.new(root: market_entity) }
    let(:new_price) { price + 1 }

    it 'updates market price' do
      update_price
      expect(market_entity).to have_received(:price=).with(new_price)
    end
  end
end
