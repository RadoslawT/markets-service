# frozen_string_literal: true

describe Commands::CreateMarket do
  describe '.call' do
    subject(:call) { described_class.call(params) }

    let(:params) do
      {
        platform: platform,
        name: name
      }
    end

    let(:platform) { :platform }
    let(:name) { 'market_name' }

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
  end
end
