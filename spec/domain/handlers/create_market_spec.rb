# frozen_string_literal: true

describe Handlers::CreateMarket do
  describe '#call' do
    subject(:call) { described_class.new.call(params) }

    let(:params) do
      {
        platform: platform,
        name: name
      }
    end
    let(:name) { 'name' }
    let(:platform) { 'platform' }

    let(:market_attributes) do
      {
        uuid: 'uuid',
        platform: platform,
        name: name,
        price: nil
      }
    end

    let(:market) do
      instance_double(entity_class, market_attributes)
    end
    let(:repository) { Repositories::Market }
    let(:entity_class) { Entities::Market }

    before do
      allow(entity_class).to receive(:create).and_return(market)
      allow(repository).to receive(:adapt).and_return(repository)
      allow(repository).to receive(:commit)
    end

    context 'when market does not exist' do
      before do
        allow(Repositories::Market).to receive(:find_by).with(platform: platform, name: name).and_return(nil)
      end

      it 'creates an Entity' do
        call
        expect(entity_class).to have_received(:create).with(platform: platform, name: name)
      end

      it 'adapts market changes into repository' do
        call
        expect(repository).to have_received(:adapt).with(market)
      end

      it 'commits market changes' do
        call
        expect(repository).to have_received(:commit)
      end
    end

    context 'when market already exists' do
      before do
        allow(Repositories::Market).to receive(:find_by).with(platform: platform, name: name).and_return(double)
      end

      it 'does not create an entity' do
        call
        expect(entity_class).not_to have_received(:create)
      end
    end
  end
end
