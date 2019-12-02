# frozen_string_literal: true

describe Commands::AddTask do
  describe '.call' do
    subject(:call) { described_class.call(params) }

    let(:params) do
      {
        market_uuid: market_uuid,
        type: type,
        completion_price: completion_price
      }
    end

    let(:market_uuid) { 'market_uuid' }
    let(:type) { :type }
    let(:completion_price) { 1.23 }

    context 'when params are valid' do
      it { is_expected.to be_success }
    end

    context 'when market_uuid is blank' do
      let(:market_uuid) { nil }

      it { is_expected.not_to be_success }
    end

    context 'when type is blank' do
      let(:type) { nil }

      it { is_expected.not_to be_success }
    end

    context 'when completion_price is blank' do
      let(:completion_price) { nil }

      it { is_expected.not_to be_success }
    end
  end
end