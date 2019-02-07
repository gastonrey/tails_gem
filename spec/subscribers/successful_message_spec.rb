# frozen_string_literal: true

describe Tails::Subscribers do
  include_context 'Message type'
  include_context 'Stomp Client'
  include_context 'Mocked Worker'

  context "When it's been initialized" do
    let(:described_class_instance) do
      described_class.new('Worker::Dummy', './spec/helpers/tails.yml')
    end

    describe 'When #subscribe_and_dispatch is invoked with a valid message' do
      it 'Then #perform is called' do
        expect(worker).to receive(:perform)
        described_class_instance
      end

      it 'Then #ACK is called for given message' do
        expect(@client).to receive(:ack)
        described_class_instance
      end
    end
  end
end
