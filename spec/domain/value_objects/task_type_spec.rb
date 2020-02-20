# frozen_string_literal: true

describe ValueObjects::TaskType do
  describe '.new' do
    subject(:task_type) { described_class.new(activation_price: activation_price, completion_price: completion_price) }

    context 'when activation price is lower than completion price' do
      let(:activation_price) { 1.0 }
      let(:completion_price) { 2.0 }
      let(:hit_type) { described_class::HIT }

      it { is_expected.to be_a_kind_of(described_class) }
      it { is_expected.to have_attributes(value: hit_type) }
    end

    context 'when activation price is higher than completion price' do
      let(:activation_price) { 2.0 }
      let(:completion_price) { 1.0 }
      let(:drop_type) { described_class::DROP }

      it { is_expected.to be_a_kind_of(described_class) }
      it { is_expected.to have_attributes(value: drop_type) }
    end

    context 'when activation and completion price are equal' do
      let(:activation_price) { 1.0 }
      let(:completion_price) { activation_price }

      it 'raises an error' do
        expect { task_type }.to raise_error(DomainErrors::IncorrectValueObject)
      end
    end
  end
end
