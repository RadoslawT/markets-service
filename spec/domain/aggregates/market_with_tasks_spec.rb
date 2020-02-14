# frozen_string_literal: true

describe Aggregates::MarketWithTasks do
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

    let(:aggregate) { described_class.new(root: market_entity, tasks: tasks) }
    let(:new_price) { price + 1 }
    let(:tasks) { [] }

    it 'updates market price' do
      update_price
      expect(market_entity).to have_received(:price=).with(new_price)
    end

    context 'when price drops below the drop task completion price' do
      let(:tasks) { [drop_task] }
      let(:drop_task) { instance_double(Entities::Task, type: ValueObjects::TaskType::DROP, completion_price: price / 2, type_drop?: true) }
      let(:new_price) { price / 3 }

      before { allow(drop_task).to receive(:complete) }

      it 'completes drop type tasks' do
        update_price
        expect(drop_task).to have_received(:complete)
      end
    end

    context 'when price drops above the drop task completion price' do
      let(:tasks) { [drop_task] }
      let(:drop_task) { instance_double(Entities::Task, type: ValueObjects::TaskType::DROP, completion_price: price / 3, type_drop?: true) }
      let(:new_price) { price / 2 }

      before { allow(drop_task).to receive(:complete) }

      it 'completes drop type tasks' do
        update_price
        expect(drop_task).not_to have_received(:complete)
      end
    end

    context 'when price raises above the hit task completion price' do
      let(:tasks) { [hit_task] }
      let(:hit_task) { instance_double(Entities::Task, type: ValueObjects::TaskType::HIT, completion_price: price * 2, type_hit?: true) }
      let(:new_price) { price * 3 }

      before { allow(hit_task).to receive(:complete) }

      it 'completes drop type tasks' do
        update_price
        expect(hit_task).to have_received(:complete)
      end
    end

    context 'when price raises below the hit task completion price' do
      let(:tasks) { [hit_task] }
      let(:hit_task) { instance_double(Entities::Task, type: ValueObjects::TaskType::HIT, completion_price: price * 3, type_hit?: true) }
      let(:new_price) { price * 2 }

      before { allow(hit_task).to receive(:complete) }

      it 'completes drop type tasks' do
        update_price
        expect(hit_task).not_to have_received(:complete)
      end
    end
  end

  describe '#add_task' do
    subject(:add_task) { aggregate.add_task(type: type, completion_price: completion_price) }

    let(:aggregate) { described_class.new(root: market_entity, tasks: tasks) }
    let(:type) { 'type' }
    let(:completion_price) { 2 }
    let(:new_task) { instance_double(Entities::Task, type: type, completion_price: completion_price) }

    before do
      allow(Entities::Task).to receive(:create).with(
        type: type,
        completion_price: completion_price,
        market_uuid: aggregate.root.uuid
      ).and_return(new_task)
    end

    context 'when the same task already exists' do
      let(:tasks) { [instance_double(Entities::Task, type: new_task.type, completion_price: new_task.completion_price)] }

      it 'does not create a new task' do
        add_task
        expect(aggregate.tasks).not_to include(new_task)
      end
    end

    context 'when the same task does not exist' do
      let(:tasks) { [] }

      it 'creates a new task' do
        add_task
        expect(aggregate.tasks).to include(new_task)
      end
    end
  end

  describe '#emit_task_completed_events' do
    subject(:emit) { aggregate.emit_task_completed_events }

    let(:aggregate) { described_class.new(root: market_entity, tasks: tasks) }

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
