# frozen_string_literal: true

describe Entities::Market do
  let(:params) do
    {
      platform: platform_name,
      name: 'market_name',
      ask_price: 1,
      bid_price: 2
    }
  end
  let(:platform_name) { 'platform_name' }
  let(:platform) { instance_double(ValueObjects::Platform, value: platform_name) }

  before do
    allow(ValueObjects::Platform).to receive(:new).with(platform_name).and_return(platform)
  end

  describe '.create' do
    subject(:market) { described_class.create(params) }

    context 'when params are valid' do
      it { is_expected.to be_a_kind_of(described_class) }
      it { is_expected.to have_attributes(params) }

      it 'has uuid' do
        expect(market.uuid).not_to be_nil
      end
    end
  end
end
