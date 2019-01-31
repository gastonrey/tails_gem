# frozen_string_literal: true

require 'securerandom'
require 'helpers/parsers'
require 'helpers/slogger'

module Tails
  class Subscribers
    include Helpers::Parsers

    attr_reader :message,
                :data_message # TODO: remove it

    def initialize(worker)
      @logger = Helpers::Slogger::Slogger.new.log
      @subscriber_config = load_configuration_from('config/tails.yml')
      @worker = Object.const_get(worker)
      @event_type = @worker.instance_variable_get "@event_type"
      subscribe_and_dispatch
    end

    def subscribe_and_dispatch
      raise Helpers::SubscriberErrors::TopicNotFound unless @event_type

      subscribe(@event_type) do |message|
        @message = message
        @data_message = parse(message.body)['data'] # TODO: remove it
        @worker.perform(message) if valid?(message)
      end
      client.join
    end

    private

    def subscribe(event)
      client.subscribe(build_queue_name(event, @worker), 
                       id: SecureRandom.uuid,
                       ack: 'client-individual') do |message|

        @logger.info("Subscribed to #{event}. "\
                     "Received message #{message.body}")

        yield message
      end
    end

    def client
      @subscriber_config[:logger] = @logger
      @client ||= Stomp::Client.new(@subscriber_config)
    rescue  Timeout::Error,
            Errno::EINVAL,
            Errno::ECONNRESET => e

      raise Helpers::SubscriberErrors::StompConnectionError, e
    end

    def valid?(message)
      if message.nil? || message.command == 'ERROR'
        @logger.warn("Message with errors found: \n" \
                    "#{message.inspect}")
        return false
      end
      true
    end
  end
end
