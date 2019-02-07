# frozen_string_literal: true

describe Tails::Subscribers do
  context 'When trying to initialize it with wrong parameters' do
    let(:described_class_instance) do
      described_class.new('Tails::Test', nil)
    end

    describe 'When described_class is instantiated without config file path' do
      it 'Then it raises a NoYamlConfigFile exception' do
        expect do
          described_class_instance
        end.to raise_error(Tails::Helpers::SubscriberErrors::NoYamlConfigFile)
      end
    end
  end
end
