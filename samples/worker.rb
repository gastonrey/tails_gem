# frozen_string_literal: true

require 'tails'

module Sonic
  class DeviceCreated < Tails::Worker
    def event_type
      "NewDevice"
    end

    def perform(msg)
      puts msg
    end
  end
end
