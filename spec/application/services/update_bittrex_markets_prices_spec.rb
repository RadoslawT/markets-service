# frozen_string_literal: true

describe Services::UpdateBittrexMarketsPrices do
  describe '.call' do
    subject(:call) { described_class.call }

    let(:api_result) do
      [
        { ask_rate: 1.23, bid_rate: 4.56, symbol: 'abc' },
        { ask_rate: 1.23, bid_rate: 4.56, symbol: 'abc' }
      ]
    end

    before do
      allow(Adapters::BittrexApi).to receive(:markets_tickers).and_return(api_result)
      allow(Commands::UpdateMarketPrice).to receive(:call)
    end

    it 'calls UpdateMarketPrice' do
      call
      expect(Commands::UpdateMarketPrice).to have_received(:call).exactly(api_result.size)
    end
  end
end
