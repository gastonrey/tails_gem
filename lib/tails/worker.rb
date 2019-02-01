module Tails
  class Worker
    def event_type
      raise NotImplementedError, 'Method should be implemented'
    end
    
    def perform
      raise NotImplementedError, 'Method should be implemented'
    end
  end
end

