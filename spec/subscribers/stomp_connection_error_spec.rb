# frozen_string_literal: true

describe Tails::Subscribers do
  include_context 'Message type'

  context "When it tries to connect to queue\'s server" do
    before do
      @client = instance_double(Stomp::Client)
      @worker = instance_double(Worker::Dummy, 
                                :perform => true,
                                :event_type => 'DeviceCreated')
  
      allow(Stomp::Client).to receive(:new).and_raise(Stomp::Error::MaxReconnectAttempts)
      
      allow(Worker::Dummy).to receive(:new).and_return(@worker)
    end
  
    let(:described_class_instance) do
      described_class.new('Worker::Dummy', './spec/helpers/tails.yml')
    end

    describe 'And it raises an error' do
      it 'Then its rescued and a custom one thrown' do
        expect{
          described_class_instance
        }.to raise_error(Tails::Helpers::SubscriberErrors::StompConnectionError)
      end
    end
  end
end
