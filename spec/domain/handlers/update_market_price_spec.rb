# frozen_string_literal: true

describe Handlers::UpdateMarketPrice do
  describe '#call' do
    subject(:call) { described_class.new.call(command: command) }

    let(:command) do
      {
        data: {
          platform: platform,
          market_name: market_name,
          market_price: market_price
        }
      }
    end
    let(:platform) { double }
    let(:market_name) { double }
    let(:market_price) { double }

    let(:market) do
      instance_double(aggregate_class)
    end
    let(:repository) { Repositories::MarketWithTasksToComplete }
    let(:aggregate_class) { Aggregates::MarketWithTasksToComplete }

    before do
      allow(market).to receive(:update_price)
      allow(market).to receive(:emit_task_completed_events)
      allow(repository).to receive(:find_by).with(platform: platform, name: market_name, new_price: market_price).and_return(market)
      allow(repository).to receive(:adapt).and_return(repository)
      allow(repository).to receive(:commit)
    end

    context 'when market does not exist' do
      before { allow(repository).to receive(:find_by).and_return(nil) }

      it 'does not update a price' do
        call
        expect(market).not_to have_received(:update_price)
      end
    end

    context 'when market exists' do
      it 'updates market price' do
        call
        expect(market).to have_received(:update_price).with(price: market_price)
      end

      it 'adapts market aggregate changes into repository' do
        call
        expect(repository).to have_received(:adapt).with(market)
      end

      it 'commits market aggregate changes' do
        call
        expect(repository).to have_received(:commit)
      end

      it 'emits task completed events' do
        call
        expect(market).to have_received(:emit_task_completed_events)
      end
    end
  end
end
