# frozen_string_literal: true

describe Tails::Subscribers do
  include_context 'Message type'
  include_context 'Stomp Client'
  include_context 'Mocked Worker'

  context "When it's been subscribed" do
    
    let(:described_class_instance) do
      described_class.new('Worker::Dummy', './spec/helpers/tails.yml')
    end
    
    describe 'And method #perform raised any error' do
      before do
        allow(worker).to receive(:perform).and_raise('Foo')
      end

      it 'Then its rescued and a custom one thrown' do
        expect do
          described_class_instance
        end.to raise_error(
          Tails::Helpers::SubscriberErrors::ErrorPerformingMessage
        )
      end
    end
  end
end
