# frozen_string_literal: true

describe Controllers::V1::MarketsController, type: :controller do
  describe '#index' do
    subject(:index) { get(:index) }

    let(:markets) { create_list(:market, 2) }
    let(:market_entities) { markets.map { |m| Entities::Market.from_repository(m.attributes) } }
    let(:serialized_markets) do
      market_entities.map do |market|
        {
          id: market.uuid,
          type: 'markets',
          attributes: {
            name: market.name,
            platform: market.platform
          }
        }
      end
    end
    let(:markets_list) do
      {
        data: serialized_markets
      }
    end

    before do
      allow(Queries::AllMarkets).to receive(:call).and_return(market_entities)
    end

    it { is_expected.to have_http_status(:ok) }

    it 'responds with json api markets list' do
      index
      expect(json_body).to eq(markets_list)
    end
  end
end
