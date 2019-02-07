# frozen_string_literal: true

describe Tails::Subscribers do
  include_context 'Message type'
  include_context 'Stomp Client'
  include_context 'Mocked Worker'

  context "When it tries to connect to queue\'s server" do
    before do
      allow(Stomp::Client).to receive(:new)
        .and_raise(Stomp::Error::MaxReconnectAttempts)
    end

    let(:described_class_instance) do
      described_class.new('Worker::Dummy', './spec/helpers/tails.yml')
    end

    describe 'And it raises an error' do
      it 'Then its rescued and a custom one thrown' do
        expect do
          described_class_instance
        end.to raise_error(
          Tails::Helpers::SubscriberErrors::StompConnectionError
        )
      end
    end
  end
end
