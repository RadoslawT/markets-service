# frozen_string_literal: true

describe Adapters::BittrexApi do
  describe '.markets_tickers' do
    subject(:markets_tickers) { described_class.markets_tickers }

    let(:api_response_body) do
      '
        [
          { "askRate": "1.23", "bidRate": "4.56", "symbol": "abc" },
          { "askRate": "1.23", "bidRate": "4.56", "symbol": "abc" }
        ]
      '
    end
    let(:api_response) { double(body: api_response_body, status: api_response_status) }

    before do
      allow(Faraday).to receive(:get).with('https://api.bittrex.com/v3/markets/tickers').and_return(api_response)
    end

    context 'when api returns proper response' do
      let(:api_response_status) { 200 }
      let(:expected_result) do
        [
          { ask_rate: 1.23, bid_rate: 4.56, symbol: 'abc' },
          { ask_rate: 1.23, bid_rate: 4.56, symbol: 'abc' }
        ]
      end

      it { is_expected.to eq(expected_result) }
    end

    context 'when api returns bad response' do
      let(:api_response_status) { 400 }

      it 'raise an error' do
        expect { markets_tickers }.to raise_error(InfrastructureErrors::BadResponse)
      end
    end
  end
end
