# frozen_string_literal: true

describe Commands::UpdateMarketPrice do
  describe '.call' do
    subject(:call) { described_class.call(params) }

    let(:params) do
      {
        platform: platform,
        market_name: market_name,
        market_price: market_price
      }
    end

    let(:platform) { 'platform' }
    let(:market_name) { 'market_name' }
    let(:market_price) { 1.23 }

    context 'when params are valid' do
      it { is_expected.to be_success }
    end

    context 'when platform is blank' do
      let(:platform) { nil }
      it { is_expected.not_to be_success }
    end

    context 'when market_name is blank' do
      let(:market_name) { nil }
      it { is_expected.not_to be_success }
    end

    context 'when price is blank' do
      let(:market_price) { nil }
      it { is_expected.not_to be_success }
    end
  end
end
