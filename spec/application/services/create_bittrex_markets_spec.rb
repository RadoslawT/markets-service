# frozen_string_literal: true

describe Services::CreateBittrexMarkets do
  describe '.call' do
    subject(:call) { described_class.call }

    let(:api_result) do
      [
        { ask_rate: ask_rate, bid_rate: bid_rate, symbol: symbol },
        { ask_rate: ask_rate, bid_rate: bid_rate, symbol: symbol }
      ]
    end
    let(:command_params) do
      {
        platform: ValueObjects::Platform::BITTREX,
        name: symbol,
        ask_price: ask_rate,
        bid_price: bid_rate
      }
    end
    let(:symbol) { 'abc' }
    let(:ask_rate) { 1.23 }
    let(:bid_rate) { 1.23 }

    before do
      allow(Adapters::BittrexApi).to receive(:markets_tickers).and_return(api_result)
      allow(Commands::CreateMarket).to receive(:call)
    end

    it 'calls CreateMarket command' do
      call
      expect(Commands::CreateMarket).to have_received(:call).with(command_params).exactly(api_result.size)
    end
  end
end
