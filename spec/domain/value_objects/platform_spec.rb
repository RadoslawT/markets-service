# frozen_string_literal: true

describe ValueObjects::Platform do
  describe '.new' do
    subject(:new_platform) { described_class.new(platform_name) }

    context 'when platform name is valid' do
      let(:platform_name) { 'bittrex' }

      it { is_expected.to be_a_kind_of(described_class) }
      it { is_expected.to have_attributes(value: platform_name) }
    end

    context 'when platform name is invalid' do
      let(:platform_name) { 'platform_name' }

      it 'raises an error' do
        expect { new_platform }.to raise_error(DomainErrors::IncorrectValueObject)
      end
    end
  end
end
