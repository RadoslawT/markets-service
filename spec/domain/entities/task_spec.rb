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
end
