# frozen_string_literal: true

describe Tails::Subscribers do
  context "When trying to initialize it with wrong parameters" do
    let(:described_class_instance) do
      lambda do |namespace='Worker::Dummy', file_path='./spec/helpers/tails.yml'|
        described_class.new(namespace, file_path)
      end
    end

    describe 'When described_class is instantiated without config file path' do
      it 'Then it raises a NoYamlConfigFile exception' do    
        expect do
          described_class_instance["Tails::Test", nil]
        end.to raise_error(Tails::Helpers::SubscriberErrors::NoYamlConfigFile)
      end
    end

    describe 'When described_class is instantiated without namespace' do
      it 'Then it raises a NoNameSpaceProvided exception' do
        expect do
          described_class_instance[nil]
        end.to raise_error(Tails::Helpers::SubscriberErrors::NoNameSpaceProvided)
      end
    end
  end
end
