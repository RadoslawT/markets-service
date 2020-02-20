# frozen_string_literal: true

describe Entities::Task do
  let(:params) do
    {
      market_uuid: 'market_uuid',
      activation_price: 1.0,
      completion_price: 2.0
    }
  end
  let(:type) { ValueObjects::TaskType::HIT }

  describe '.create' do
    subject(:task) { described_class.create(params) }

    context 'when params are valid' do
      it { is_expected.to be_a_kind_of(described_class) }
      it { is_expected.to have_attributes(params) }

      it 'has uuid' do
        expect(task.uuid).not_to be_nil
      end

      it 'has a correct type' do
        expect(task.type).to eq(type)
      end
    end
  end

  describe '#complete' do
    subject(:complete) { task.complete }

    let(:task) { described_class.from_repository(params) }

    it 'delets the task' do
      complete
      expect(task.deleted?).to be true
    end
  end

  describe '#completed?' do
    subject(:complete) { task.completed? }

    let(:task) { described_class.from_repository(params) }

    context 'when task is completed' do
      before { task.complete }

      it { is_expected.to be true }
    end

    context 'when task is not completed' do
      it { is_expected.to be false }
    end
  end
end
