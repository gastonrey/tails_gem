# frozen_string_literal: true

describe Tails::Subscribers do
  include_context 'Message type'

  context "When it's been initialized without Namespace" do
    before do
      @client = instance_double(Stomp::Client)
      @worker = 'No::Worker'
  
      allow(Stomp::Client).to receive(:new).and_return @client
      allow(@client).to receive(:subscribe).and_yield(@message)
      allow(@client).to receive(:join).and_return(true)
      allow(@client).to receive(:ack).and_return(true)
      
      allow(Worker::Dummy).to receive(:new).and_return(@worker)
    end
  
    let(:described_class_instance) do
      described_class.new(@worker, './spec/helpers/tails.yml')
    end

    describe 'When any namespace was provided or it does not exist' do
      it 'Then an error is thrown' do
        expect{
          described_class_instance
        }.to raise_error(Tails::Helpers::SubscriberErrors::NoNameSpaceProvided)
      end
    end
  end
end
