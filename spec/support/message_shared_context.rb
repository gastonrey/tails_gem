shared_context "Message type" do |type='Success'|
  before do
    @message = instance_double( 'Stomp::Message',
                                'command' => type,
                                'body' => {
                                  data: { device_id: 22_323_234_234_234 }
                                }.to_json,
                                'headers' => {
                                  'ack' => 'ID:11127d687303-33927-1543317841043-55:1'
                                })
  end    
end
