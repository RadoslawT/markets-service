# frozen_string_literal: true

describe Entities::Task do
  let(:params) do
    {
      market_uuid: 'market_uuid',
      type: type,
      completion_price: 1.0
    }
  end
  let(:type) { :type }
  let(:task_type) { instance_double(ValueObjects::TaskType, value: type) }

  before do
    allow(ValueObjects::TaskType).to receive(:new).with(type).and_return(task_type)
  end

  describe '.create' do
    subject(:task) { described_class.create(params) }

    context 'when params are valid' do
      it { is_expected.to be_a_kind_of(described_class) }
      it { is_expected.to have_attributes(params) }

      it 'has uuid' do
        expect(task.uuid).not_to be_nil
      end
    end
  end

  describe '#type_drop?' do
    subject { task.type_drop? }

    let(:task) { described_class.create(params) }

    context 'when type drop' do
      let(:type) { ValueObjects::TaskType::DROP }

      it { is_expected.to be true }
    end

    context 'when type hit' do
      let(:type) { ValueObjects::TaskType::HIT }

      it { is_expected.to be false }
    end
  end

  describe '#type_hit?' do
    subject { task.type_hit? }

    let(:task) { described_class.create(params) }

    context 'when type hit' do
      let(:type) { ValueObjects::TaskType::HIT }

      it { is_expected.to be true }
    end

    context 'when type drop' do
      let(:type) { ValueObjects::TaskType::DROP }

      it { is_expected.to be false }
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

    let(:task) { described_class.from_repository(params)  }

    context 'when task is completed' do
      before { task.complete }

      it { is_expected.to be true }
    end

    context 'when task is not completed' do
      it { is_expected.to be false }
    end
  end
end
