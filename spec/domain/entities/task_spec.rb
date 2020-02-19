# frozen_string_literal: true

describe Entities::Task do
  let(:activation_price) { 1 }
  let(:completion_price) { 2 }
  let(:market_uuid) { double }
  let(:market_price_change) do
    ValueObjects::MarketPriceChange.new(
      market_uuid: market_uuid,
      from: activation_price,
      to: completion_price
    )
  end
  let(:attributes) do
    {
      market_uuid: market_uuid,
      activation_price: activation_price,
      completion_price: completion_price,
      type: market_price_change.type
    }
  end

  describe '.create' do
    subject(:task) { described_class.create(create_params) }

    let(:create_params) { { market_price_change: market_price_change } }

    context 'when params are valid' do
      it { is_expected.to be_a_kind_of(described_class) }
      it { is_expected.to have_attributes(attributes) }

      it 'has uuid' do
        expect(task.uuid).not_to be_nil
      end
    end
  end

  describe '#complete' do
    subject(:complete) { task.complete }

    let(:task) { described_class.from_repository(attributes) }

    it 'delets the task' do
      complete
      expect(task.deleted?).to be true
    end
  end

  describe '#completed?' do
    subject(:complete) { task.completed? }

    let(:task) { described_class.from_repository(attributes) }

    context 'when task is completed' do
      before { task.complete }

      it { is_expected.to be true }
    end

    context 'when task is not completed' do
      it { is_expected.to be false }
    end
  end
end
