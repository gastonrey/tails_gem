shared_context 'Stomp Client' do
  before do
    @client = instance_double(Stomp::Client)

    allow(Stomp::Client).to receive(:new).and_return @client
    allow(@client).to receive(:subscribe).and_yield(message)
    allow(@client).to receive(:join).and_return(true)
    allow(@client).to receive(:ack).and_return(true)
  end
end
