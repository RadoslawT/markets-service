# frozen_string_literal: true

describe Consumers::AlertSet do
  describe '#call' do
    subject(:call) { described_class.new.call(event) }

    let(:event) do
      {
        name: event_name,
        data: {
          activation_price: activation_price,
          trigger_price: trigger_price,
          market_uuid: market_uuid
        }
      }
    end

    let(:event_name) { 'alert_set' }
    let(:market_uuid) { double }
    let(:activation_price) { 2 }
    let(:trigger_price) { 1 }
    let(:expected_params) do
      {
        market_uuid: market_uuid,
        completion_price: trigger_price,
        activation_price: activation_price
      }
    end

    before do
      allow(Commands::AddTask).to receive(:call)
    end

    context 'when event_name is alert_set' do
      let(:event_name) { 'alert_set' }

      it 'calls the AddTask command' do
        call
        expect(Commands::AddTask).to have_received(:call).with(expected_params)
      end
    end

    context 'when event_name is different than alert_set' do
      let(:event_name) { 'name' }

      it 'does not call the AddTask command' do
        call
        expect(Commands::AddTask).not_to have_received(:call)
      end
    end
  end
end
