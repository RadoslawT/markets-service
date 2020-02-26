# frozen_string_literal: true

describe Commands::CreateMarket do
  describe '.call' do
    subject(:call) { described_class.call(params) }

    let(:params) do
      {
        platform: platform,
        name: name,
        ask_price: ask_price,
        bid_price: bid_price
      }
    end

    let(:platform) { :platform }
    let(:name) { 'market_name' }
    let(:ask_price) { 1.23 }
    let(:bid_price) { 1.23 }

    context 'when params are valid' do
      it { is_expected.to be_success }
    end

    context 'when platform is blank' do
      let(:platform) { nil }

      it { is_expected.not_to be_success }
    end

    context 'when market_name is blank' do
      let(:name) { nil }

      it { is_expected.not_to be_success }
    end

    context 'when ask_price is blank' do
      let(:ask_price) { nil }

      it { is_expected.not_to be_success }
    end

    context 'when bid_price is blank' do
      let(:bid_price) { nil }

      it { is_expected.not_to be_success }
    end
  end
end
