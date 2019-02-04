# frozen_string_literal: true

module Worker
  class Dummy < Tails::Worker
    def event_type
      "NewDevice"
    end

    def perform(msg)
      puts msg
    end
  end
end
