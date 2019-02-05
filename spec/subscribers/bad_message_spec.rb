# frozen_string_literal: true

describe Tails::Subscribers do
  include_context 'Message type', 'ERROR'

  context "When it's been initialized" do
    before do
      client = instance_double(Stomp::Client)
      worker = instance_double(Dummy::Worker, :perform => true)
  
      allow(Stomp::Client).to receive(:new).and_return client
      allow(client).to receive(:subscribe).and_yield(@message)
      allow(client).to receive(:join).and_return(true)
      allow(client).to receive(:ack).and_return(true)
      allow(Dummy::Worker).to receive(:new).and_return(worker)
    end
  
    let(:described_class_instance) do
      described_class.new('Worker::Dummy', './spec/tails.yml')
    end

    describe 'When #subscribe_and_dispatch is invoked with an invalid message' do
      it 'Then #perform is never called' do
        expect(described_class_instance.worker).not_to receive(:perform)
      end
    end
  end
end
