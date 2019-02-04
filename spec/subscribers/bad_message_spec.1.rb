# frozen_string_literal: true
# $LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')

describe Tails::Subscribers do
  let(:message) do
    lambda do |type='Success'|
      instance_double('Stomp::Message',
                      'command' => type,
                      'body' => {
                        data: { device_id: 22_323_234_234_234 }
                      }.to_json,
                      'headers' => {
                        'ack' => 'ID:11127d687303-33927-1543317841043-55:1'
                      })
    end
  end

  context "When trying to initialize it with wrong parameters" do
    let(:described_class_instance) do
      lambda do |namespace='Worker::Dummy', file_path='./spec/helpers/tails.yml'|
        described_class.new(namespace, file_path)
      end
    end

    describe 'When described_class is instantiated without config file path' do
      it 'Then it raises a NoYamlConfigFile exception' do    
        expect do
          described_class_instance["Tails::Test", nil]
        end.to raise_error(Tails::Helpers::SubscriberErrors::NoYamlConfigFile)
      end
    end

    describe 'When described_class is instantiated without namespace' do
      it 'Then it raises a NoNameSpaceProvided exception' do
        expect do
          described_class_instance[nil]
        end.to raise_error(Tails::Helpers::SubscriberErrors::NoNameSpaceProvided)
      end
    end
  end

  context "When it's been initialized" do
    before do
      client = instance_double(Stomp::Client)
  
      allow(Stomp::Client).to receive(:new).and_return client
      allow(client).to receive(:subscribe).and_yield(message[])
      allow(client).to receive(:join).and_return(true)
      allow(client).to receive(:ack).and_return(true)
    end
  
    let(:described_class_instance) do
      described_class.new('Worker::Dummy', './spec/tails.yml')
    end
    
    describe 'When #subscribe_and_dispatch is invoked with a valid topic' do
      it 'Then instance variable #message is created' do
        expect(described_class.worker).to receive(:perform)
        expect(described_class_instance.message).to be_instance_of(message[].class)
      end
    end

    describe 'When #subscribe_and_dispatch is invoked with an invalid message' do
      it 'Then #perform is never called' do
        expect(described_class_instance.worker).not_to receive(:perform)
      end
    end
  end

  # describe 'When #subscribe_and_dispatch is invoked with a valid topic' do
  #   before do
  #     base_class.subscribe_and_dispatch(:device_created)
  #   end

  #   it 'Then instance variables are sert with #message and #data_message' do
  #     expect(base_class.message).not_to be_nil
  #     expect(base_class.data_message).not_to be_nil
  #   end
  # end

  # describe 'When #subscribe_and_dispatch is invoked with an invalid topic' do
  #   it 'Then it raises an exception' do
  #     expect do
  #       base_class.subscribe_and_dispatch(nil)
  #     end.to raise_error(Helpers::SubscriberErrors::TopicNotFound)
  #   end
  # end

  # describe 'When #subscribe_and_dispatch is invoked with an invalid message' do
  #   it 'Then #dispatch is never called' do
  #     allow(base_class).to receive(:valid?).and_return(false)
  #     expect(base_class).not_to receive(:dispatch)
  #     expect(base_class.subscribe_and_dispatch(:device_created)).to be_truthy
  #   end
  # end

  # context 'when Stomp client can not be created' do
  #   describe 'And #Timeout::Error exception is caught' do
  #     before do
  #       allow(Stomp::Client).to receive(:new).and_raise Timeout::Error
  #     end

  #     it 'Then the custom one #StompConnectionError is raised' do
  #       expect do
  #         described_class.new.subscribe_and_dispatch(:device_created)
  #       end.to raise_error(Helpers::SubscriberErrors::StompConnectionError)
  #     end
  #   end
  # end

  # describe 'when #dispatch method is called and not defined' do
  #   it 'Then a #NotImplementedError exception is thrown' do
  #     expect do
  #       described_class.new.subscribe_and_dispatch(:device_created)
  #     end.to raise_error(NotImplementedError)
  #   end
  # end

  # context 'when #valid? is invoked' do
  #   describe 'and receives a nil message' do
  #     it 'Then it returns false' do
  #       expect(described_class.new.send(:valid?, nil)).to be_falsey
  #     end
  #   end

  #   describe 'and receives a message with errors' do
  #     let(:message) do
  #       instance_double('Stomp::Message', 'command' => 'ERROR')
  #     end

  #     it 'Then it returns false' do
  #       expect(described_class.new.send(:valid?, message)).to be_falsey
  #     end
  #   end

  #   describe 'when message is valid' do
  #     it 'Then it returns true' do
  #       expect(described_class.new.send(:valid?, successful_message)).to be_truthy
  #     end
  #   end
  # end
end
