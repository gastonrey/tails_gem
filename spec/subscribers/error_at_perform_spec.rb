# frozen_string_literal: true

describe Tails::Subscribers do
  include_context 'Message type'

  context "When it's been subscribed" do
    before do
      @client = instance_double(Stomp::Client)
      @worker = instance_double(Worker::Dummy, 
                                :perform => true,
                                :event_type => 'DeviceCreated')
  
      allow(Stomp::Client).to receive(:new).and_return @client
      allow(@client).to receive(:subscribe).and_yield(@message)
      allow(@client).to receive(:join).and_return(true)
      allow(@client).to receive(:ack).and_return(true)
      
      allow(Worker::Dummy).to receive(:new).and_return(@worker)
      allow(@worker).to receive(:perform).and_raise('Foo')
    end
  
    let(:described_class_instance) do
      described_class.new("Worker::Dummy", './spec/helpers/tails.yml')
    end

    describe 'And method #perform raised any error' do
      it 'Then its rescued and a custom one thrown' do
        expect{
          described_class_instance
        }.to raise_error(Tails::Helpers::SubscriberErrors::ErrorPerformingMessage)
      end
    end
  end
end
