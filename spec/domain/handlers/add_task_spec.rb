# frozen_string_literal: true

describe Handlers::AddTask do
  describe '#call' do
    subject(:call) { described_class.new.call(command: command) }

    let(:command) do
      {
        data: {
          market_uuid: market_uuid,
          type: type,
          completion_price: completion_price
        }
      }
    end
    let(:market_uuid) { 'market_uuid' }
    let(:type) { :platform }
    let(:completion_price) { 1.23 }

    # let(:market_attributes) do
    #   {
    #     uuid: 'uuid',
    #     platform: platform,
    #     name: name,
    #     price: nil
    #   }
    # end

    let(:market) do
      instance_double(aggregate_class)
    end
    let(:repository) { Repositories::MarketAggregate }
    let(:aggregate_class) { Aggregates::Market }

    before do
      allow(market).to receive(:add_task)
      allow(repository).to receive(:adapt).and_return(repository)
      allow(repository).to receive(:commit)
    end

    context 'when market does not exist' do
      before do
        allow(Repositories::MarketAggregate).to receive(:find_by).with(uuid: market_uuid).and_return(nil)
      end

      it 'does not add a task to market' do
        call
        expect(market).not_to have_received(:add_task)
      end
    end

    context 'when market exists' do
      before do
        allow(Repositories::MarketAggregate).to receive(:find_by).with(uuid: market_uuid).and_return(market)
      end

      it 'adds a task to market' do
        call
        expect(market).to have_received(:add_task).with(completion_price: completion_price, type: type)
      end

      it 'adapts market aggregate changes into repository' do
        call
        expect(repository).to have_received(:adapt).with(market)
      end

      it 'commits market aggregate changes' do
        call
        expect(repository).to have_received(:commit)
      end
    end
  end
end