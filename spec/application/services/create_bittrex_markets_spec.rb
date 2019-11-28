# frozen_string_literal: true

describe Services::CreateBittrexMarkets do
  describe '.call' do
    subject(:call) { described_class.call }

    let(:api_result) do
      [
        { ask_rate: 1.23, bid_rate: 4.56, symbol: symbol },
        { ask_rate: 1.23, bid_rate: 4.56, symbol: symbol }
      ]
    end
    let(:symbol) { 'abc' }

    before do
      allow(Adapters::BittrexApi).to receive(:markets_tickers).and_return(api_result)
      allow(Commands::CreateMarket).to receive(:call)
    end

    it 'calls CreateMarket command' do
      call
      expect(Commands::CreateMarket).to have_received(:call).with(platform: ValueObjects::Platform::BITTREX, name: symbol).exactly(api_result.size)
    end
  end
end
