# frozen_string_literal: true

describe Tails::Subscribers do
  include_context 'Message type'

  context "When it's been initialized" do
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
    end
  
    let(:described_class_instance) do
      described_class.new('Worker::Dummy', './spec/helpers/tails.yml')
    end

    describe 'When #subscribe_and_dispatch is invoked with a valid message' do
      it 'Then #perform is called' do
        expect(@worker).to receive(:perform)
        described_class_instance
      end

      it "Then #ACK is called for given message" do
        expect(@client).to receive(:ack)
        described_class_instance
      end
    end
  end
end
