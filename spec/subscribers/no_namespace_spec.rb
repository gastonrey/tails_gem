# frozen_string_literal: true

describe Tails::Subscribers do
  context "When it's been initialized without Namespace" do
    include_context 'Message type'
    include_context 'Stomp Client', @message
    
    let(:described_class_instance) do
      described_class.new("Foo::Bar", './spec/helpers/tails.yml')
    end

    describe 'When any namespace was provided or it does not exist' do
      it 'Then an error is thrown' do
        expect do
          described_class_instance
        end.to raise_error(
          Tails::Helpers::SubscriberErrors::NoNameSpaceProvided
        )
      end
    end
  end
end
