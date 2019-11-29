# frozen_string_literal: true

describe ValueObjects::TaskType do
  describe '.new' do
    subject(:task_type) { described_class.new(type) }

    context 'when type is valid' do
      let(:type) { described_class::HIT }

      it { is_expected.to be_a_kind_of(described_class) }
      it { is_expected.to have_attributes(value: type) }
    end

    context 'when type is invalid' do
      let(:type) { 'type' }

      it 'raises an error' do
        expect { task_type }.to raise_error(DomainErrors::IncorrectValueObject)
      end
    end
  end
end
