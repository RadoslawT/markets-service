# frozen_string_literal: true

describe Aggregates::MarketWithTasksToComplete do
  let(:market_entity) { instance_double(Entities::Market, price: price, uuid: 'uuid') }
  let(:price) { 1.0 }

  before do
    allow(market_entity).to receive(:price=)
  end

  describe '.new' do
    subject(:market) { described_class.new(root: market_entity) }

    it { is_expected.to be_a_kind_of(described_class) }

    it 'has root' do
      expect(market.root).to eq(market_entity)
    end
  end

  describe '#update_price' do
    subject(:update_price) { aggregate.update_price(price: new_price) }

    let(:aggregate) { described_class.new(root: market_entity, tasks_to_complete: tasks) }
    let(:new_price) { price + 1 }
    let(:tasks) { [] }

    it 'updates market price' do
      update_price
      expect(market_entity).to have_received(:price=).with(new_price)
    end
  end

  describe '#emit_task_completed_events' do
    subject(:emit) { aggregate.emit_task_completed_events }

    let(:aggregate) { described_class.new(root: market_entity, tasks_to_complete: tasks) }

    before { allow(Events::MarketTaskCompleted).to receive(:call) }

    context 'when completed tasks are present' do
      let(:tasks) { [completed_task] }
      let(:completed_task) { instance_double(Entities::Task, completed?: true, market_uuid: double, type: type, completion_price: double) }
      let(:type) { :type }
      let(:expected_payload) do
        {
          market_uuid: completed_task.market_uuid,
          completion_price: completed_task.completion_price,
          type: completed_task.type.to_s
        }
      end

      it 'emits MarketTaskCompleted event' do
        emit
        expect(Events::MarketTaskCompleted).to have_received(:call).with(expected_payload)
      end
    end

    context 'when there is no completed task' do
      let(:tasks) { [uncompleted_task] }
      let(:uncompleted_task) { instance_double(Entities::Task, completed?: false) }

      it 'emits MarketTaskCompleted event' do
        emit
        expect(Events::MarketTaskCompleted).not_to have_received(:call)
      end
    end
  end
end