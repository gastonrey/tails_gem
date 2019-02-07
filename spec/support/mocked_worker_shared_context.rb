shared_context 'Mocked Worker' do |raise_error=false|
  let(:worker){ 
    instance_double(Worker::Dummy,
                    perform: true,
                    event_type: "DeviceCreated")}
  
  before do
    allow(Worker::Dummy).to receive(:new).and_return(worker)
    if raise_error
      allow(worker).to receive(:event_type).and_raise(NoMethodError)
    else
      allow(worker).to receive(:event_type).and_return(true)
    end
  end
end
