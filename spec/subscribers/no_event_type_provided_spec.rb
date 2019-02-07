# frozen_string_literal: true

describe Tails::Subscribers do
  context "When it's been initialized without #event_type method defined" do
    describe 'When worker object throws NoMethodError exception' do
      include_context 'Message type'
      include_context 'Stomp Client'
      include_context 'Mocked Worker', true
    
      let(:described_class_instance) do
        described_class.new('Worker::Dummy', './spec/helpers/tails.yml')
      end
      it 'Then its rescued and a custom one is thrown' do
        expect do
          described_class_instance
        end.to raise_error(
          Tails::Helpers::SubscriberErrors::EventTypeNotPresent
        )
      end
    end
  end
end
