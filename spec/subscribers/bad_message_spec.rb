# frozen_string_literal: true

describe Tails::Subscribers do
  include_context 'Message type', 'ERROR'

  context "When it's been initialized" do
    include_context 'Message type', 'ERROR'
    include_context 'Stomp Client'
    include_context 'Mocked Worker'

    let(:described_class_instance) do
      described_class.new('Worker::Dummy', './spec/helpers/tails.yml')
    end

    describe 'When #subscribe_and_dispatch is invoked with an invalid message' do
      it 'Then #perform is never called' do
        expect(worker).not_to receive(:perform)
        described_class_instance
      end

      it 'Then ACK is never called for given message' do
        expect(@client).not_to receive(:ack)
        described_class_instance
      end
    end
  end
end
